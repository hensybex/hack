import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class RouteProvider with ChangeNotifier {
  List<Polyline?> _routePolylines = [null, null, null];
  List<double?> _travelTimes = [null, null, null];
  int? _selectedRoute = 0;

  List<Polyline?> get routePolylines => _routePolylines;
  List<double?> get travelTimes => _travelTimes;
  int? get selectedRoute => _selectedRoute;

  void setRoutePolyline(
      Polyline carPolyline, Polyline bikePolyline, Polyline footPolyline) {
    _routePolylines[0] = carPolyline;
    _routePolylines[1] = bikePolyline;
    _routePolylines[2] = footPolyline;
    notifyListeners();
  }

  void setTravelTime(
      double carTravelTime, double bikeTravelTime, double footTravelTime) {
    _travelTimes[0] = carTravelTime;
    _travelTimes[1] = bikeTravelTime;
    _travelTimes[2] = footTravelTime;
    notifyListeners();
  }

  void setSelectedRoute(int index) {
    _selectedRoute = index;
    notifyListeners();
  }
}
