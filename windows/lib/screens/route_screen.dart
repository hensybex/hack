import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hack/models/office.dart';
import 'package:hack/tools/palette.dart';
import 'package:hack/tools/providers/displayed_objects.dart';
import 'package:hack/tools/providers/routes.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class IconDoubleData {
  final String iconPath;
  final double time;

  IconDoubleData(this.iconPath, this.time);
}

class RouteScreen extends StatefulWidget {
  final int officeId;

  const RouteScreen({Key? key, required this.officeId}) : super(key: key);

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  Office? office;
  RouteState _state = RouteState.selection;
  int _activeContainerIndex = -1;
  List<Marker> _markersAds = [];
  final mapController = MapController();

  Office? getOfficeById(int officeId) {
    final officeBox = Hive.box<Office>('offices');
    return officeBox.values.firstWhere(
      (office) => office.id == officeId,
      orElse: () {
        Office defaultOffice = Office(
          id: -1,
          salePointName: 'Default Office',
          address: 'Default Address',
          status: 'Default Status',
          openHours: [Hours(days: 'Mon-Fri', hours: '9:00-18:00')],
          rko: 'Default RKO',
          openHoursIndividual: [Hours(days: 'Mon-Fri', hours: '9:00-18:00')],
          officeType: 'Default Type',
          salePointFormat: 'Default Format',
          suoAvailability: 'Default SUO Availability',
          hasRamp: 'Default Ramp',
          latitude: 0.0,
          longitude: 0.0,
          metroStation: 'Default Metro',
          distance: 0,
          kep: false,
          myBranch: false,
          radiusDistance: 0.0,
        );
        return defaultOffice;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    office = getOfficeById(widget.officeId);
    print('Retrieved Office: $office');
  }

  @override
  Widget build(BuildContext context) {
    final objects =
        Provider.of<DisplayedObjectsProvider>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: objects.currentLocation,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: _markersAds,
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
              if ((_state == RouteState.ready &&
                      context.watch<RouteProvider>().routePolylines[0] !=
                          null) ||
                  (_state == RouteState.selection &&
                      context.watch<RouteProvider>().selectedRoute != null))
                PolylineLayer(
                  polylines: [
                    context.watch<RouteProvider>().routePolylines[
                        context.watch<RouteProvider>().selectedRoute!]!
                  ],
                ),
            ],
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
            top: 10.0,
            left: 10.0,
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/left.svg',
                width: 50,
                height: 50,
              ),
              onPressed: () => context.go('/office/${widget.officeId}'),
            ),
          ),

          if (_state == RouteState.selection) _buildSelectionState(),
          if (_state == RouteState.preStart) _buildPreStartState(),
          // If _state is RouteState.ready, the map itself will display the route.
        ],
      ),
    );
  }

  String formatMilliseconds(double milliseconds) {
    int totalSeconds = (milliseconds / 1000).round();
    int minutes = totalSeconds ~/ 60;
    int hours = minutes ~/ 60;
    minutes = minutes % 60;

    String hourStr = '';
    if (hours == 1 || hours == 21) {
      hourStr = '$hours:';
    } else if (hours >= 2 && hours <= 4 || (hours >= 22 && hours <= 24)) {
      hourStr = '$hours:';
    } else if (hours >= 5) {
      hourStr = '$hours:';
    }

    String minuteStr = '';
    if (minutes == 1 ||
        minutes == 21 ||
        minutes == 31 ||
        minutes == 41 ||
        minutes == 51) {
      minuteStr = '$minutes мин';
    } else if (minutes >= 2 && minutes <= 4 ||
        (minutes >= 22 && minutes <= 24) ||
        (minutes >= 32 && minutes <= 34) ||
        (minutes >= 42 && minutes <= 44) ||
        (minutes >= 52 && minutes <= 54)) {
      minuteStr = '$minutes мин';
    } else if (minutes >= 5) {
      minuteStr = '$minutes мин';
    }

    if (hours > 0) {
      return hourStr + (minuteStr.isNotEmpty ? minuteStr : '');
    } else {
      return minuteStr;
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

  Widget _buildSelectionState() {
    final List<IconDoubleData> iconDoubleList = [
      IconDoubleData(
          "assets/icons/car.svg",
          context
              .watch<RouteProvider>()
              .travelTimes[0]!), // Replace with actual text or function call
      IconDoubleData("assets/icons/bike.svg",
          context.watch<RouteProvider>().travelTimes[1]!),
      IconDoubleData("assets/icons/foot.svg",
          context.watch<RouteProvider>().travelTimes[2]!),
    ];

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        color: context.watch<Palette>().darkBackground,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // First Row: Back button and 'Route' text
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/left.svg',
                    width: 50,
                    height: 50,
                  ),
                  onPressed: () => context.go('/office/${widget.officeId}'),
                ),
                const Text(
                  'Маршрут',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'VTB Group UI',
                    fontSize: 30.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
                const Text(
                  '1 / 2',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'VTB Group UI',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),

            // Three containers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return GestureDetector(
                  onTap: () {
                    context.read<RouteProvider>().setSelectedRoute(index);
                    setState(() => _activeContainerIndex = index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.watch<Palette>().greyBackground,
                      border: Border.all(
                        color: _activeContainerIndex == index
                            ? Colors.blue
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          iconDoubleList[index].iconPath,
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          formatMilliseconds(iconDoubleList[index].time),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'VTB Group UI',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10.0),
            Text(
              office!.salePointName,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'VTB Group UI',
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
            Spacer(),
            Container(
              width: 158,
              height: 47,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff0A2896), Color(0xff1E4BD2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26.0),
              ),
              child: TextButton(
                onPressed: () => setState(() => _state = RouteState.preStart),
                child: const Text(
                  'Далее',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'VTB Group UI',
                    fontSize: 30.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreStartState() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        color: context.watch<Palette>().darkBackground,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/left.svg',
                    width: 50,
                    height: 50,
                  ),
                  onPressed: () =>
                      setState(() => _state = RouteState.selection),
                ),
                const Text(
                  'Маршрут',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'VTB Group UI',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
                const Text(
                  '2 / 2',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'VTB Group UI',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            const Text(
              'Сколько займёт времени',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'VTB Group UI',
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
            Text(
              'Выйдете из отделения в ' + ,
              style: TextStyle(
                color: context.watch<Palette>().greyText,
                fontFamily: 'VTB Group UI',
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 20.0),
            const Row(
                // Placeholder for the empty row
                ),
            const Divider(),
            const SizedBox(height: 10.0),
            // TalonWidget placeholder
            Container(
              height: 50,
              width: double.infinity,
              color: Colors.blueAccent,
              child: const Center(child: Text('TalonWidget Placeholder')),
            ),
            const Divider(),
            Spacer(),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff0A2896), Color(0xff1E4BD2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26.0),
              ),
              child: TextButton(
                onPressed: () => setState(() => _state = RouteState.ready),
                child: const Text(
                  'Построить маршрут',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'VTB Group UI',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
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

  // Add functions to switch between states, make backend calls, etc.
  // ...
}

enum RouteState { selection, preStart, ready }
