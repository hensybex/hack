// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VoiceRecordingAdapter extends TypeAdapter<VoiceRecording> {
  @override
  final int typeId = 7;

  @override
  VoiceRecording read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoiceRecording(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VoiceRecording obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.filePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceRecordingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
