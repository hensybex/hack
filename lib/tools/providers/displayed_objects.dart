import 'package:flutter/foundation.dart';
import 'package:hack/models/atm.dart';
import 'package:hack/models/office.dart';
import 'package:latlong2/latlong.dart';

class DisplayedObjectsProvider with ChangeNotifier {
  List<Atm> _atms = [];
  List<Office> _offices = [];

  LatLng _currentLocation = const LatLng(55.7558, 37.6173);

  List<Atm> get atms => _atms;
  List<Office> get offices => _offices;

  LatLng get currentLocation => _currentLocation;

  void setAtms(List<Atm> atms) {
    _atms = atms;
    print(atms.length);
    notifyListeners();
  }

  void setOffices(List<Office> offices) {
    _offices = offices;
    print(offices.length);
    notifyListeners();
  }

  void setCurrentLocation(LatLng newLocation) {
    _currentLocation = newLocation;
    notifyListeners();
  }
}
