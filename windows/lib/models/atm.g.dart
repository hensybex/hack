// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'atm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AtmAdapter extends TypeAdapter<Atm> {
  @override
  final int typeId = 0;

  @override
  Atm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Atm(
      id: fields[0] as int,
      address: fields[1] as String,
      latitude: fields[2] as double,
      longitude: fields[3] as double,
      allDay: fields[4] as bool,
      services: fields[5] as Services,
      radiusDistance: fields[6] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Atm obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.allDay)
      ..writeByte(5)
      ..write(obj.services)
      ..writeByte(6)
      ..write(obj.radiusDistance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AtmAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServicesAdapter extends TypeAdapter<Services> {
  @override
  final int typeId = 1;

  @override
  Services read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Services(
      wheelchair: fields[0] as Service,
      blind: fields[1] as Service,
      nfcForBankCards: fields[2] as Service,
      qrRead: fields[3] as Service,
      supportsChargeRub: fields[5] as Service,
      supportsEur: fields[6] as Service,
      supportsRub: fields[7] as Service,
      supportsUsd: fields[4] as Service,
    );
  }

  @override
  void write(BinaryWriter writer, Services obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.wheelchair)
      ..writeByte(1)
      ..write(obj.blind)
      ..writeByte(2)
      ..write(obj.nfcForBankCards)
      ..writeByte(3)
      ..write(obj.qrRead)
      ..writeByte(4)
      ..write(obj.supportsUsd)
      ..writeByte(5)
      ..write(obj.supportsChargeRub)
      ..writeByte(6)
      ..write(obj.supportsEur)
      ..writeByte(7)
      ..write(obj.supportsRub);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServicesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ServiceAdapter extends TypeAdapter<Service> {
  @override
  final int typeId = 2;

  @override
  Service read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Service(
      serviceActivity: fields[1] as String,
      serviceCapability: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Service obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.serviceCapability)
      ..writeByte(1)
      ..write(obj.serviceActivity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
