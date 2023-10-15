// voice_recording.dart
import 'package:hive/hive.dart';

part 'voice.g.dart'; // name of the generated file

@HiveType(typeId: 7) // Unique identifier for this type
class VoiceRecording {
  @HiveField(0)
  final String filePath;

  VoiceRecording(this.filePath);
}
