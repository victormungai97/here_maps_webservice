import 'package:equatable/equatable.dart';

import 'address.dart';
import 'mapview.dart';
import 'category.dart';
import 'geoposition.dart';

/// This class models the result from Reverse Geocoding API call to Dart code
/// For more information on this, visit https://developer.here.com/documentation/geocoding-search-api/dev_guide/topics/endpoint-reverse-geocode-brief.html
class ReverseGeocode extends Equatable {
  /// Representative string for the result.
  /// In case of address it is the complete postal address string
  final String title;

  /// the identifier of the result object.
  /// Its value can be used to retrieve the very same object through the `/lookup` endpoint.
  final String id;

  /// ISO3 country code of the item political view (default for international).
  /// This response element is populated when the politicalView parameter is set in the query
  final String politicalView;

  /// Type of item HERE Geocoding and Search `/revgeocode` is able to return.
  ///
  /// Includes `houseNumber`, `place`, `locality`, `street`, etc.
  final String resultType;

  /// Type of address data (returned only for address results)
  ///
  /// `PA`: Point Address, location matches as individual point object.
  ///
  /// `interpolated`: Location is the interpolated point on an address range line object.
  final String houseNumberType;

  ///  Enum: `"postalCode"` `"subdistrict"` `"district"` `"city" `
  final String localityType;

  /// Indicates that the requested house number was corrected to match the nearest known house number if `true`.
  /// This field is visible only when the value is `true`.
  final bool houseNumberFallback;

  /// Detailed address of the result.
  final Address? address;

  /// Distance, in `meters`, to the given spatial context.
  final int distance;

  /// Bounding box of the location enclosing the geometric shape (area or line), optimized for display, that an individual result covers.
  /// `place` typed results have no `mapView`.
  final MapView? mapView;

  /// Representative geo-position (WGS 84) of the result.
  /// This is to be used to display the result on a map
  final GeoPosition? position;

  /// Geo-position of the access to the result (for instance the entrance)
  final List<GeoPosition?>? access;

  /// The list of categories assigned to this place.
  final List<Category?>? categories;

  const ReverseGeocode._({
    this.title = "",
    this.id = "",
    this.politicalView = "",
    this.resultType = "",
    this.localityType = "",
    this.houseNumberType = "",
    this.houseNumberFallback = false,
    this.address,
    this.mapView,
    this.position,
    this.distance = 0,
    this.access = const [],
    this.categories = const [],
  });

  factory ReverseGeocode({
    String title = "",
    String id = "",
    String politicalView = "",
    String resultType = "",
    String houseNumberType = "",
    GeoPosition? position,
    MapView? mapView,
    Address? address,
    int distance = 0,
    String localityType = "",
    bool houseNumberFallback = false,
    List<GeoPosition?>? access = const [],
    List<Category?>? categories = const [],
  }) =>
      ReverseGeocode._(
        title: title,
        id: id,
        politicalView: politicalView,
        resultType: resultType,
        houseNumberType: houseNumberType,
        localityType: localityType,
        categories: categories,
        address: address,
        access: access,
        mapView: mapView,
        distance: distance,
        position: position,
        houseNumberFallback: houseNumberFallback,
      );

  factory ReverseGeocode.fromJson(Map<String?, dynamic>? json) {
    List<GeoPosition?>? access;
    if (json == null ||
        json["access"] == null ||
        !(json["access"] is List) ||
        json["access"] == []) {
      access = [];
    } else {
      List list = json["access"];
      access = list.map((element) => GeoPosition.fromJson(element)).toList();
    }

    List<Category?>? categories;
    if (json == null ||
        json["categories"] == null ||
        !(json["categories"] is List) ||
        json["categories"] == []) {
      access = [];
    } else {
      List list = json["categories"];
      categories = list.map((element) => Category.fromJson(element)).toList();
    }

    return ReverseGeocode(
      title: json?["title"] ?? "",
      id: json?["id"] ?? "",
      politicalView: json?["politicalView"] ?? "",
      resultType: json?["resultType"] ?? "",
      localityType: json?["localityType"] ?? "",
      houseNumberType: json?["houseNumberType"] ?? "",
      address: Address.fromJson(json?["address"] ?? {}),
      mapView: MapView.fromJson(json?["mapView"] ?? {}),
      position: GeoPosition.fromJson(json?["position"] ?? {}),
      houseNumberFallback: json?["houseNumberFallback"] ?? false,
      distance: json?["distance"] ?? 0,
      categories: categories,
      access: access,
    );
  }

  static Map<String, dynamic>? toJson(ReverseGeocode? reverseGeocode) {
    List<Map<String?, dynamic>?>? access;
    if (reverseGeocode == null ||
        reverseGeocode.access == null ||
        !(reverseGeocode.access is List<GeoPosition?>?) ||
        reverseGeocode.access == []) {
      access = [];
    } else {
      final list = reverseGeocode.access ?? [];
      access = list.map((element) => GeoPosition.toJson(element)).toList();
    }

    List<Map<String?, dynamic>?>? categories;
    if (reverseGeocode == null ||
        reverseGeocode.categories == null ||
        !(reverseGeocode.categories is List<Category?>?) ||
        reverseGeocode.categories == []) {
      categories = [];
    } else {
      final list = reverseGeocode.categories ?? [];
      categories = list.map((element) => Category.toJson(element)).toList();
    }

    return <String, dynamic>{
      "title": reverseGeocode?.title ?? "",
      "id": reverseGeocode?.id ?? "",
      "politicalView": reverseGeocode?.politicalView ?? "",
      "resultType": reverseGeocode?.resultType ?? "",
      "localityType": reverseGeocode?.localityType ?? "",
      "houseNumberType": reverseGeocode?.houseNumberType ?? "",
      "position": GeoPosition.toJson(reverseGeocode?.position),
      "mapView": MapView.toJson(reverseGeocode?.mapView),
      "address": Address.toJson(reverseGeocode?.address),
      "access": access,
      "categories": categories,
      "distance": reverseGeocode?.distance ?? 0,
      "houseNumberFallback": reverseGeocode?.houseNumberFallback ?? false,
    };
  }

  @override
  List<Object?> get props => [
        title,
        id,
        politicalView,
        resultType,
        localityType,
        houseNumberType,
        access,
        mapView,
        position,
        distance,
        categories,
        houseNumberFallback,
      ];
}
