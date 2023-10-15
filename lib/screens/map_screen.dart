import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:hack/backend/populate_boxes.dart';
import 'package:hack/models/atm.dart';
import 'package:hack/models/office.dart';
import 'package:hack/tools/providers/displayed_objects.dart';
import 'package:hack/tools/providers/voice.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

typedef VoidCallback = void Function();

VoidCallback debounce(VoidCallback callback, Duration delay) {
  Timer? _debounceTimer;
  return () {
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(delay, callback);
  };
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapController = MapController();
  MapPosition? _lastPosition;
  late VoidCallback debouncedUpdateMarkers;
  List<Marker> _markers = [];
  Timer? _scrollingDebounceTimer;
  double? _displayedRadius;

  @override
  void initState() {
    super.initState();

    final objects =
        Provider.of<DisplayedObjectsProvider>(context, listen: false);
    debouncedUpdateMarkers =
        debounce(_updateMarkers, const Duration(seconds: 1));
    Future.delayed(Duration.zero, _updateMarkers);
    objects.setCurrentLocation(LatLng(55.7558, 37.6173));
  }

  @override
  void dispose() {
    _scrollingDebounceTimer?.cancel();
    super.dispose();
  }

  bool _userStoppedScrolling(MapPosition position) {
    /* print(_lastPosition!.center!.latitude.toString() +
        ' ' +
        _lastPosition!.center!.longitude.toString());
    print(position.center!.latitude.toString() +
        ' ' +
        position.center!.longitude.toString());
    print('\n'); */
    if (_lastPosition == null) {
      _lastPosition = position;
      return false;
    }

    if (_lastPosition!.zoom == position.zoom &&
        _lastPosition!.center == position.center) {
      _lastPosition = null;
      return true;
    }

    _lastPosition = position;
    return false;
  }

  Future<void> _updateMarkers() async {
    LatLng center = mapController.camera.center;
    double radius = computeRadius(mapController.camera.zoom);

    await populateHiveBoxes(center.latitude, center.longitude, radius);

    await fetchFromHive();

    final markers = getMarkers();

    setState(() {
      _markers = markers;
    });
  }

  double computeRadius(double zoomLevel) {
    return (400 * pow(2, (15 - zoomLevel))).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final objects =
        Provider.of<DisplayedObjectsProvider>(context, listen: false);
    final voiceProvider = Provider.of<VoiceProvider>(context, listen: false);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: objects.currentLocation,
              initialZoom: 15.0,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  // Reset the timer if it's already running
                  _scrollingDebounceTimer?.cancel();

                  // Start a new timer
                  _scrollingDebounceTimer =
                      Timer(const Duration(seconds: 1), () {
                    _updateMarkers();
                  });
                }
                setState(() {
                  _displayedRadius = computeRadius(position.zoom!);
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: _markers,
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () =>
                        launchUrl('https://openstreetmap.org/copyright'),
                  ),
                ],
              ),
              /* CircleLayer(
                circles: [
                  CircleMarker(
                    point: mapController.camera.center,
                    color: Colors.transparent,
                    borderColor: Colors.blue,
                    borderStrokeWidth: 2,
                    useRadiusInMeter: true,
                    radius: computeRadius(mapController.camera.zoom),
                  ),
                ],
              ), */
            ],
          ),
          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Поиск отделения',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onSubmitted: (value) {
                            // TODO: Handle submission
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.mic),
                        onPressed: () {
                          voiceProvider.pressVoiceButton();
                          //voiceProvider.endVoiceInput();
                        },
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Handle category button press
                        },
                        child: Text('Category ${index + 1}'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      context.go('/pin_list');
                    },
                    child: const Text('Список объектов'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Handle right footer button press
                    },
                    child: const Text('Button 2'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _customCircularButton(
                    backgroundColor: const Color(0xFF191C20),
                    iconData: Icons.add,
                    onPressed: () {
                      double currentZoom = mapController.zoom;
                      mapController.move(
                          mapController.center, currentZoom + 1.0);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  _customCircularButton(
                    backgroundColor: const Color(0xFF191C20),
                    iconData: Icons.remove,
                    onPressed: () {
                      double currentZoom = mapController.camera.zoom;
                      mapController.move(
                          mapController.camera.center, currentZoom - 1.0);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  _customCircularButton(
                    backgroundColor: const Color(0xFF191C20),
                    iconData: Icons.location_on,
                    onPressed: () {
                      mapController.move(
                          const LatLng(55.7558, 37.6173), mapController.zoom);
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Material(
              color: Colors.white,
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  "Radius: ${_displayedRadius?.toStringAsFixed(2)} m",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  fetchFromHive() async {
    final locationProvider =
        Provider.of<DisplayedObjectsProvider>(context, listen: false);

    final atmBox = await Hive.openBox<Atm>('atms');
    final officeBox = await Hive.openBox<Office>('offices');

    locationProvider.setAtms(atmBox.values.toList());
    locationProvider.setOffices(officeBox.values.toList());
  }

  List<Marker> getMarkers() {
    final locationProvider =
        Provider.of<DisplayedObjectsProvider>(context, listen: false);
    List<Marker> markers = [];

    locationProvider.atms.forEach((atm) {
      markers.add(Marker(
        point: LatLng(atm.latitude, atm.longitude),
        child: const Icon(Icons.atm),
      ));
    });

    locationProvider.offices.forEach((office) {
      markers.add(Marker(
        point: LatLng(office.latitude, office.longitude),
        child: const Icon(Icons.business_center),
      ));
    });

    return markers;
  }

  void _handlePositionChange(MapPosition position, bool hasGesture) {
    if (hasGesture) {
      debouncedUpdateMarkers();
    }
  }

  Widget _customCircularButton({
    required Color backgroundColor,
    required IconData iconData,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 50.0, // or desired width
      height: 50.0, // or desired height
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(iconData, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Future<void> launchUrl(String urlString) async {
    if (await canLaunch(urlString)) {
      await launch(urlString);
    } else {
      throw 'Could not launch $urlString';
    }
  }
}
