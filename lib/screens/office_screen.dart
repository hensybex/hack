import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hack/backend/main_service.dart';
import 'package:hack/models/office.dart';
import 'package:hack/tools/image_slider.dart';
import 'package:hack/tools/palette.dart';
import 'package:hack/tools/providers/displayed_objects.dart';
import 'package:hack/tools/providers/office_screen_state.dart';
import 'package:hack/tools/providers/routes.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class RouteResponse {
  final List<Path> paths;

  RouteResponse({required this.paths});

  factory RouteResponse.fromJson(Map<String, dynamic> json) {
    return RouteResponse(
      paths: (json['paths'] as List).map((i) => Path.fromJson(i)).toList(),
    );
  }
}

class Path {
  final Points points;
  final double time; // in seconds

  Path({required this.points, required this.time});

  factory Path.fromJson(Map<String, dynamic> json) {
    return Path(
      points: Points.fromJson(json['points']),
      time: json['time'].toDouble(), // assuming it's given in seconds
    );
  }
}

class Points {
  final String type;
  final List<List<double>> coordinates;

  Points({required this.type, required this.coordinates});

  factory Points.fromJson(Map<String, dynamic> json) {
    return Points(
      type: json['type'],
      coordinates: (json['coordinates'] as List)
          .map((i) => List<double>.from(i))
          .toList(),
    );
  }
}

class OfficeScreen extends StatefulWidget {
  final int officeId;

  const OfficeScreen({Key? key, required this.officeId}) : super(key: key);

  @override
  State<OfficeScreen> createState() => _OfficeScreenState();
}

class _OfficeScreenState extends State<OfficeScreen> {
  Office? office;
  List<int> minutesToGet = [];

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
          service: [],
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
    if (office == null) {
      return const Scaffold(
        body: Center(child: Text('Office not found')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.watch<Palette>().darkBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/pin_list'); // Navigate back to Map screen.
          },
        ),
        title: const Center(child: Text('Отделение')),
      ),
      backgroundColor: context.watch<Palette>().darkBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200, // Set your desired height
              color: Colors.grey, // Placeholder color
              child: ImageSliderWidget(photoUrls: const [
                'assets/images/image_0.png',
                'assets/images/image_1.png'
              ]),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: context.watch<Palette>().greyBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    office!.salePointName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    office!.address,
                    style: TextStyle(
                      color: context.watch<Palette>().greyText,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                          onPressed: () async {
                            final routeProvider = Provider.of<RouteProvider>(
                                context,
                                listen: false);
                            BackendService service = BackendService();
                            final displayedObjectsProvider =
                                Provider.of<DisplayedObjectsProvider>(context,
                                    listen: false);

                            String startPositions =
                                '${displayedObjectsProvider.currentLocation.latitude},${displayedObjectsProvider.currentLocation.longitude}';
                            String finishPositions =
                                '${office!.latitude},${office!.longitude}';

                            displayedObjectsProvider.currentLocation.longitude
                                .toString();
                            RouteResponse carResponse =
                                await service.fetchRoute(
                                    startPositions: startPositions,
                                    finishPositions: finishPositions,
                                    type: 'car');
                            RouteResponse bikeResponse =
                                await service.fetchRoute(
                                    startPositions: startPositions,
                                    finishPositions: finishPositions,
                                    type: 'bike');
                            RouteResponse footResponse =
                                await service.fetchRoute(
                                    startPositions: startPositions,
                                    finishPositions: finishPositions,
                                    type: 'foot');
                            Polyline carPolyline =
                                createPolylineFromRoute(carResponse);
                            double carTravelTime = carResponse.paths[0].time;
                            Polyline bikePolyline =
                                createPolylineFromRoute(bikeResponse);
                            double bikeTravelTime = bikeResponse.paths[0].time;
                            Polyline footPolyline =
                                createPolylineFromRoute(footResponse);
                            double footTravelTime = footResponse.paths[0].time;
                            routeProvider.setRoutePolyline(
                                carPolyline, bikePolyline, footPolyline);
                            routeProvider.setTravelTime(
                                carTravelTime, bikeTravelTime, footTravelTime);

                            context.go('/route/${widget.officeId}');
                          },
                          child: const Text(
                            'Маршрут',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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
                          onPressed: () {
                            context.go('/talons/${widget.officeId}');
                          },
                          child: const Text(
                            'Взять талон',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            /* const Text('Расписание'),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                return Container(
                  width: 30,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Button ${index + 1}'),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              color: Colors.blue,
            ), */
            const SizedBox(height: 8),
            Consumer<ButtonProvider>(
              builder: (context, buttonProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: buttonProvider.activeButton == 0
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      onPressed: () {
                        buttonProvider.setActiveButton(0);
                      },
                      child: const Text('Описание'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: buttonProvider.activeButton == 1
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      onPressed: () {
                        buttonProvider.setActiveButton(1);
                      },
                      child: const Text('Услуги'),
                    ),
                  ],
                );
              },
            ),
            Consumer<ButtonProvider>(
              builder: (context, buttonProvider, child) {
                if (buttonProvider.activeButton == 0) {
                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      Divider(
                        color: context.watch<Palette>().dividerColor,
                        thickness: 2,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Обслуживание',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'VTB Group UI',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      office!.openHoursIndividual[0].days != 'Не обслуживает ФЛ'
                          ? customRow('assets/icons/people.svg',
                              "Физические лица", "Все клиенты банка", null)
                          : const SizedBox.shrink(),
                      office!.openHours[0].days != 'Не обслуживает ЮЛ'
                          ? customRow(
                              'assets/icons/people.svg',
                              "Юридические лица",
                              "Юридические клиенты банка",
                              null)
                          : const SizedBox.shrink(),
                      const SizedBox(height: 16),
                      customRow(
                          'assets/icons/premium.svg',
                          "Зона премиального обслуживания",
                          'Клиенты с пакетом "Привелегия"',
                          null),
                      const SizedBox(height: 16),
                      Divider(
                        color: context.watch<Palette>().dividerColor,
                        thickness: 2,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Доступная среда',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'VTB Group UI',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      customRow('assets/icons/limited.svg',
                          "Доступно для маломобильных граждан", null, null),
                      const SizedBox(height: 16),
                      Divider(
                        color: context.watch<Palette>().dividerColor,
                        thickness: 2,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Ближайшая станция метро',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'VTB Group UI',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      customRow(
                          'assets/icons/train.svg',
                          extractMetro(office!.metroStation)[1],
                          extractMetro(office!.metroStation)[0],
                          office!.distance),
                      const SizedBox(height: 16),
                      Divider(
                        color: context.watch<Palette>().dividerColor,
                        thickness: 2,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Режим работы',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'VTB Group UI',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      office!.openHoursIndividual[0].days != 'Не обслуживает ФЛ'
                          ? customRow(
                              'assets/icons/working_hours.svg',
                              "Для физических лиц",
                              office!.openHoursIndividual[0].hours,
                              null)
                          : const SizedBox.shrink(),
                      office!.openHours[0].days != 'Не обслуживает ЮЛ'
                          ? customRow(
                              'assets/icons/working_hours.svg',
                              "Для юридических лиц",
                              office!.openHours[0].hours,
                              null)
                          : const SizedBox.shrink(),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      Divider(
                        color: context.watch<Palette>().dividerColor,
                        thickness: 2,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Обслуживание',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'VTB Group UI',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Wrap(
                        spacing: 8.0, // space between adjacent chips
                        runSpacing: 16.0, // space between lines
                        children: office!.service.map((serviceText) {
                          return Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: const Color(0xFF282B32),
                            ),
                            child: Text(
                              serviceText,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'VTB Group UI',
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<String> extractMetro(String input) {
    List<String> parts = input.split(',').map((s) => s.trim()).toList();
    if (parts.length < 3) {
      return [
        'Unknown Line',
        'Unknown Station'
      ]; // or however you want to handle it
    }

    String metroLine = parts[1];
    String station = parts[2].split(' ').skip(1).join(' ');
    print('\'' + input + '\'');
    print(metroLine);

    return [metroLine ?? "", station ?? ""];
  }

  Padding customRow(
      String path, String name, String? description, int? distance) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            height: MediaQuery.of(context).size.width * 0.15,
            child: Center(
              child: SvgPicture.asset(
                path,
                width: 50,
                height: 50,
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'VTB Group UI',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5.0),
                description != null
                    ? Text(
                        description,
                        style: TextStyle(
                          color: context.watch<Palette>().greyText,
                          fontFamily: 'VTB Group UI',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                      )
                    : const SizedBox.shrink(),
                distance != null
                    ? Text(
                        distance.toString() + 'м',
                        style: TextStyle(
                          color: context.watch<Palette>().blueText,
                          fontFamily: 'VTB Group UI',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Polyline createPolylineFromRoute(RouteResponse routeResponse) {
    return Polyline(
      points: routeResponse.paths[0].points.coordinates
          .map((coords) => LatLng(coords[1], coords[0]))
          .toList(),
      strokeWidth: 2.0,
      color: Colors.red,
    );
  }
}
