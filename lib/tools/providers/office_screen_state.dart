import 'package:flutter/material.dart';

class ButtonProvider with ChangeNotifier {
  int _activeButton = 0;

  int get activeButton => _activeButton;

  void setActiveButton(int index) {
    _activeButton = index;
    notifyListeners();
  }
}
