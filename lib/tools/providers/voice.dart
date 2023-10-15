import 'package:flutter/foundation.dart';

class VoiceProvider extends ChangeNotifier {
  bool _voiceButtonPressed = false;
  bool _voiceInputEnded = false;

  bool get voiceButtonPressed => _voiceButtonPressed;
  bool get voiceInputEnded => _voiceInputEnded;

  void pressVoiceButton() {
    _voiceButtonPressed = true;
    _voiceInputEnded =
        false; // Reset this value whenever the button is pressed.
    notifyListeners();
  }

  void endVoiceInput() {
    _voiceInputEnded = true;
    notifyListeners();
  }

  void reset() {
    _voiceButtonPressed = false;
    _voiceInputEnded = false;
    notifyListeners();
  }
}
