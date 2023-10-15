import 'package:hack/backend/main_service.dart';
import 'package:hack/models/atm.dart';
import 'package:hack/models/office.dart';
import 'package:hive/hive.dart';

Future<void> populateHiveBoxes(
    double userLat, double userLng, double radius) async {
  final backendService = BackendService();
  final atms = await backendService.fetchAtms(
      userLat: userLat, userLng: userLng, radius: radius);
  final offices = await backendService.fetchOffices(
      userLat: userLat, userLng: userLng, radius: radius);

  final atmBox = Hive.box<Atm>('atms');
  final officeBox = Hive.box<Office>('offices');

  for (var atm in atms) {
    if (!atmBox.values.contains(atm)) {
      atmBox.add(atm);
    }
  }

  for (var office in offices) {
    if (!officeBox.values.contains(office)) {
      officeBox.add(office);
    }
  }
}
