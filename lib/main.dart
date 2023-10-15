import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hack/backend/main_service.dart';
import 'package:hack/models/atm.dart';
import 'package:hack/models/office.dart';
import 'package:hack/models/partner.dart';
import 'package:hack/models/voice.dart';
import 'package:hack/screens/not_found.dart';
import 'package:hack/tools/palette.dart';
import 'package:hack/tools/providers/displayed_objects.dart';
import 'package:hack/tools/providers/office_screen_state.dart';
import 'package:hack/tools/providers/routes.dart';
import 'package:hack/tools/providers/sorting.dart';
import 'package:hack/tools/providers/voice.dart';
import 'package:hack/tools/router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey(debugLabel: 'scaffoldMessengerKey');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await Hive.deleteBoxFromDisk('atms');
  //await Hive.deleteBoxFromDisk('offices');
  await Hive.initFlutter();
  try {
    await Hive.deleteBoxFromDisk('offices');
  } catch (e) {
    print('Error deleting the box: $e');
  }
  try {
    await Hive.deleteBoxFromDisk('atms');
  } catch (e) {
    print('Error deleting the box: $e');
  }

  Hive.registerAdapter(AtmAdapter());
  Hive.registerAdapter(OfficeAdapter());
  Hive.registerAdapter(HoursAdapter());
  Hive.registerAdapter(ServicesAdapter());
  Hive.registerAdapter(ServiceAdapter());
  Hive.registerAdapter(PartnerAdapter());
  Hive.registerAdapter(CoordinatesAdapter());
  //Hive.registerAdapter(VoiceRecordingAdapter());

  await Hive.openBox<Atm>('atms');
  await Hive.openBox<Office>('offices');
  //await Hive.openBox<VoiceRecording>('voices');

  //await populateHiveBoxes(55.7558, 37.6173, 400.0);

  BackendService service = BackendService();
  final partnersBox = await Hive.openBox<Partner>('partners');

// After fetching the data from the service
  List<Partner> fetchedPartners = await service.fetchPartners();
  for (Partner partner in fetchedPartners) {
    partnersBox.add(partner);
  }

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  static final _router = GoRouter(
      routes: routes,
      errorBuilder: (context, state) {
        return NotFoundScreen(
          errorMessage: state.error.toString(),
        );
      });

  const MyApp({
    super.key,
  });

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => DisplayedObjectsProvider()),
          //ChangeNotifierProvider(create: (context) => VoiceProvider()),
          ChangeNotifierProvider(create: (context) => RouteProvider()),
          ChangeNotifierProvider(create: (context) => ButtonProvider()),
          ChangeNotifierProvider(create: (context) => SortingProvider()),
          Provider(
            create: (context) => Palette(),
          ),
        ],
        child: Builder(builder: (context) {
          //final palette = context.watch<Palette>();

          return MaterialApp.router(
            title: 'VTB',
            /* theme: ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                seedColor: palette.darkPen,
                background: palette.backgroundMain,
              ),
              textTheme: TextTheme(
                bodyMedium: TextStyle(
                  color: palette.ink,
                ),
              ),
              useMaterial3: true,
            ), */
            routeInformationProvider: MyApp._router.routeInformationProvider,
            routeInformationParser: MyApp._router.routeInformationParser,
            routerDelegate: MyApp._router.routerDelegate,
            scaffoldMessengerKey: scaffoldMessengerKey,
          );
        }));
  }
}
