// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfficeAdapter extends TypeAdapter<Office> {
  @override
  final int typeId = 3;

  @override
  Office read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Office(
      id: fields[0] as int,
      salePointName: fields[1] as String,
      address: fields[2] as String,
      status: fields[3] as String,
      openHours: (fields[4] as List).cast<Hours>(),
      rko: fields[5] as String,
      openHoursIndividual: (fields[6] as List).cast<Hours>(),
      officeType: fields[7] as String,
      salePointFormat: fields[8] as String,
      suoAvailability: fields[9] as String,
      hasRamp: fields[10] as String,
      latitude: fields[11] as double,
      longitude: fields[12] as double,
      metroStation: fields[13] as String,
      distance: fields[14] as int,
      kep: fields[15] as bool,
      myBranch: fields[16] as bool,
      radiusDistance: fields[17] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Office obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.salePointName)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.openHours)
      ..writeByte(5)
      ..write(obj.rko)
      ..writeByte(6)
      ..write(obj.openHoursIndividual)
      ..writeByte(7)
      ..write(obj.officeType)
      ..writeByte(8)
      ..write(obj.salePointFormat)
      ..writeByte(9)
      ..write(obj.suoAvailability)
      ..writeByte(10)
      ..write(obj.hasRamp)
      ..writeByte(11)
      ..write(obj.latitude)
      ..writeByte(12)
      ..write(obj.longitude)
      ..writeByte(13)
      ..write(obj.metroStation)
      ..writeByte(14)
      ..write(obj.distance)
      ..writeByte(15)
      ..write(obj.kep)
      ..writeByte(16)
      ..write(obj.myBranch)
      ..writeByte(17)
      ..write(obj.radiusDistance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfficeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HoursAdapter extends TypeAdapter<Hours> {
  @override
  final int typeId = 4;

  @override
  Hours read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Hours(
      days: fields[0] as String,
      hours: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Hours obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.days)
      ..writeByte(1)
      ..write(obj.hours);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HoursAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
