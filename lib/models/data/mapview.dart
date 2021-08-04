import 'package:equatable/equatable.dart';

class MapView extends Equatable {
  /// Latitude of the northern-side of the box.
  final double north;

  /// Latitude of the southern-side of the box.
  final double south;

  /// Longitude of the eastern-side of the box.
  final double east;

  /// Longitude of the western-side of the box.
  final double west;

  const MapView._({
    this.north = 0.0,
    this.south = 0.0,
    this.east = 0.0,
    this.west = 0.0,
  });

  factory MapView({
    double? north = 0.0,
    double? south = 0.0,
    double? east = 0.0,
    double? west = 0.0,
  }) =>
      MapView._(
        north: north ?? 0.0,
        south: south ?? 0.0,
        east: east ?? 0.0,
        west: west ?? 0.0,
      );

  factory MapView.fromJson(Map<String?, dynamic>? json) => MapView(
        north: json?["north"] ?? 0.0,
        south: json?["south"] ?? 0.0,
        east: json?["east"] ?? 0.0,
        west: json?["south"] ?? 0.0,
      );

  static Map<String, dynamic>? toJson(MapView? mapView) => {
        "north": mapView?.north ?? 0.0,
        "south": mapView?.south ?? 0.0,
        "east": mapView?.east ?? 0.0,
        "west": mapView?.south ?? 0.0,
      };

  @override
  List<Object?> get props => [north, south, east, west];
}
