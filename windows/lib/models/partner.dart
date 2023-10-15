import 'package:hive/hive.dart';

part 'partner.g.dart';

@HiveType(typeId: 5) // Ensure the typeId is unique and not used by other models
class Partner {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String icon;

  @HiveField(3)
  final Coordinates coordinates;

  Partner({
    required this.title,
    required this.description,
    required this.icon,
    required this.coordinates,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      coordinates: Coordinates.fromJson(json['coordinates']),
    );
  }
}

@HiveType(typeId: 6)
class Coordinates {
  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
    );
  }
}
