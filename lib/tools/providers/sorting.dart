import 'package:flutter/material.dart';
import 'package:hack/models/office.dart';

class SortingProvider with ChangeNotifier {
  List<String> _activeFilters = [];

  List<String> get activeServices => _activeFilters;

  bool get hasActiveFilters => _activeFilters.isNotEmpty;

  void setActiveFilters(List<String> filters) {
    _activeFilters = filters;
    notifyListeners();
  }

  List<Office> sortOffices(List<Office> offices) {
    if (_activeFilters.isEmpty) {
      return offices;
    }

    var filteredOffices = offices.where((office) {
      return office.service.any((service) => _activeFilters.contains(service));
    }).toList();

    return filteredOffices;
  }
}
