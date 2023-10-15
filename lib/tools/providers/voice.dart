/* import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter_voice_recorder/flutter_voice_recorder.dart';
import 'package:web_socket_channel/io.dart';

class VoiceProvider extends ChangeNotifier {
  late FlutterVoiceRecorder _recorder;
  bool _voiceButtonPressed = false;
  bool _voiceInputEnded = false;
  IOWebSocketChannel? _channel; // for the WebSocket

  bool get voiceButtonPressed => _voiceButtonPressed;
  bool get voiceInputEnded => _voiceInputEnded;

  VoiceProvider() {
    _recorder = FlutterVoiceRecorder("voice_recording.mp4",
        audioFormat: AudioFormat.AAC // Providing the audioFormat parameter
        );
  }

  Future<void> initRecorder() async {
    await _recorder.initialized;
  }

  Future<void> pressVoiceButton() async {
    if (_voiceButtonPressed) {
      _voiceButtonPressed = false;
      await _recorder.stop();
      await _sendAudioFile(_recorder.recording?.path);
      _channel?.sink.close(); // Close the web socket when done
    } else {
      _voiceButtonPressed = true;
      await _recorder.start();
    }
    notifyListeners();
  }

  Future<void> pauseRecording() async {
    await _recorder.pause();
  }

  Future<void> resumeRecording() async {
    await _recorder.resume();
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
    await initRecorder(); // Re-initialize for next recording
  }

  Future<void> _sendAudioFile(String? path) async {
    if (path == null) return;

    File audioFile = File(path);
    List<int> audioBytes = await audioFile.readAsBytes();

    _channel = IOWebSocketChannel.connect('ws://194.87.252.63:2700');
    _channel!.sink.add(audioBytes);
    _channel!.stream.listen((message) {
      // Handle incoming messages from the server
    });
  }

  void reset() {
    _voiceButtonPressed = false;
    _voiceInputEnded = false;
    notifyListeners();
  }
}
 */