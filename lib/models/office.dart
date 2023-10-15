import 'package:hive/hive.dart';

part 'office.g.dart'; // Name of the generated file

@HiveType(typeId: 3)
class Office {
  @HiveField(0)
  int id;

  @HiveField(1)
  String salePointName;

  @HiveField(2)
  String address;

  @HiveField(3)
  String status;

  @HiveField(4)
  List<Hours> openHours;

  @HiveField(5)
  String rko;

  @HiveField(6)
  List<Hours> openHoursIndividual;

  @HiveField(7)
  String officeType;

  @HiveField(8)
  String salePointFormat;

  @HiveField(9)
  String suoAvailability;

  @HiveField(10)
  String hasRamp;

  @HiveField(11)
  double latitude;

  @HiveField(12)
  double longitude;

  @HiveField(13)
  String metroStation;

  @HiveField(14)
  int distance;

  @HiveField(15)
  bool kep;

  @HiveField(16)
  bool myBranch;

  @HiveField(17)
  double radiusDistance;

  @HiveField(18)
  List<String> service;

  Office({
    required this.id,
    required this.salePointName,
    required this.address,
    required this.status,
    required this.openHours,
    required this.rko,
    required this.openHoursIndividual,
    required this.officeType,
    required this.salePointFormat,
    required this.suoAvailability,
    required this.hasRamp,
    required this.latitude,
    required this.longitude,
    required this.metroStation,
    required this.distance,
    required this.kep,
    required this.myBranch,
    required this.radiusDistance,
    required this.service,
  });

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      id: json['id'] as int,
      salePointName: json['salePointName'] as String,
      address: json['address'] as String,
      status: json['status'] as String,
      openHours: (json['openHours'] as List)
          .map((e) => Hours.fromJson(e as Map<String, dynamic>))
          .toList(),
      rko: json['rko'] as String,
      openHoursIndividual: (json['openHoursIndividual'] as List)
          .map((e) => Hours.fromJson(e as Map<String, dynamic>))
          .toList(),
      officeType: json['officeType'] as String,
      salePointFormat: json['salePointFormat'] as String,
      suoAvailability: json['suoAvailability'] as String,
      hasRamp: json['hasRamp'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      metroStation: json['metroStation'] as String,
      distance: json['distance'] as int,
      kep: json['kep'] as bool,
      myBranch: json['myBranch'] as bool,
      radiusDistance: json['radius_distance'] as double,
      service: List<String>.from(json['services']),
    );
  }
}

@HiveType(typeId: 4)
class Hours {
  @HiveField(0)
  String days;

  @HiveField(1)
  String hours;
  Hours({
    required this.days,
    required this.hours,
  });

  factory Hours.fromJson(Map<String, dynamic> json) {
    return Hours(
      days: json['days'] as String,
      hours: json['hours'] as String,
    );
  }
}
