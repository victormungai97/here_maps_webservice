import 'package:equatable/equatable.dart';

class GeoPosition extends Equatable {
  /// Latitude of the address. For example: `52.19404`
  final double latitude;

  /// Longitude of the address. For example: `8.80135`
  final double longitude;

  const GeoPosition._({this.latitude = 0.0, this.longitude = 0.0});

  factory GeoPosition({double? latitude = 0.0, double? longitude = 0.0}) =>
      GeoPosition._(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0);

  factory GeoPosition.fromJson(Map<String?, dynamic>? json) => GeoPosition(
        latitude: json?["lat"] ?? 0.0,
        longitude: json?["lng"] ?? 0.0,
      );

  static Map<String, dynamic>? toJson(GeoPosition? geoPosition) => {
        "lat": geoPosition?.latitude ?? 0.0,
        "lng": geoPosition?.longitude ?? 0.0,
      };

  @override
  List<Object?> get props => [latitude, longitude];
}
