import 'package:hive/hive.dart';

part 'atm.g.dart'; // Name of the generated file

@HiveType(typeId: 0)
class Atm {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String address;

  @HiveField(2)
  final double latitude;

  @HiveField(3)
  final double longitude;

  @HiveField(4)
  final bool allDay;

  @HiveField(5)
  final Services services;

  @HiveField(6)
  double radiusDistance;

  Atm({
    required this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.allDay,
    required this.services,
    required this.radiusDistance,
  });

  factory Atm.fromJson(Map<String, dynamic> json) {
    return Atm(
      id: json['id'] as int,
      address: json['address'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      allDay: json['allDay'] as bool,
      services: Services.fromJson(json['services'] as Map<String, dynamic>),
      radiusDistance: json['radius_distance'] as double,
    );
  }
}

@HiveType(typeId: 1)
class Services {
  @HiveField(0)
  Service wheelchair;

  @HiveField(1)
  Service blind;

  @HiveField(2)
  Service nfcForBankCards;

  @HiveField(3)
  Service qrRead;

  @HiveField(4)
  Service supportsUsd;

  @HiveField(5)
  Service supportsChargeRub;

  @HiveField(6)
  Service supportsEur;

  @HiveField(7)
  Service supportsRub;

  Services({
    required this.wheelchair,
    required this.blind,
    required this.nfcForBankCards,
    required this.qrRead,
    required this.supportsChargeRub,
    required this.supportsEur,
    required this.supportsRub,
    required this.supportsUsd,
  });

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      wheelchair: Service.fromJson(json['wheelchair'] as Map<String, dynamic>),
      blind: Service.fromJson(json['blind'] as Map<String, dynamic>),
      nfcForBankCards:
          Service.fromJson(json['nfcForBankCards'] as Map<String, dynamic>),
      qrRead: Service.fromJson(json['qrRead'] as Map<String, dynamic>),
      supportsUsd:
          Service.fromJson(json['supportsUsd'] as Map<String, dynamic>),
      supportsChargeRub:
          Service.fromJson(json['supportsChargeRub'] as Map<String, dynamic>),
      supportsEur:
          Service.fromJson(json['supportsEur'] as Map<String, dynamic>),
      supportsRub:
          Service.fromJson(json['supportsRub'] as Map<String, dynamic>),
    );
  }
}

@HiveType(typeId: 2)
class Service {
  @HiveField(0)
  String serviceCapability;

  @HiveField(1)
  String serviceActivity;
  Service({
    required this.serviceActivity,
    required this.serviceCapability,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceActivity: json['serviceActivity'] as String,
      serviceCapability: json['serviceCapability'] as String,
    );
  }
}
