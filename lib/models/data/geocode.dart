import 'package:equatable/equatable.dart';

import 'score.dart';
import 'address.dart';
import 'mapview.dart';
import 'category.dart';
import 'geoposition.dart';

/// This class models the result from Geocoding API call to Dart code
/// For more information on this, visit https://developer.here.com/documentation/geocoding-search-api/dev_guide/topics/endpoint-geocode-brief.html
class Geocode extends Equatable {
  /// The localized display name of this result item.
  final String title;

  /// The unique identifier for the result item.
  /// This ID can be used for a Look Up by ID search as well.
  final String id;

  /// ISO3 country code of the item political view (default for international).
  /// This response element is populated when the politicalView parameter is set in the query
  final String politicalView;

  /// Type of item HERE Geocoding and Search `/geocode` is able to return.
  ///
  /// Includes `houseNumber`, `place`, `locality`, `street`, etc.
  final String resultType;

  /// Type of address data (returned only for address results)
  ///
  /// `PA`: Point Address, location matches as individual point object.
  ///
  /// `interpolated`: Location was interpolated from an address range
  final String houseNumberType;

  ///  Enum: `"block"` `"subblock"`
  final String addressBlockType;

  ///  Enum: `"postalCode"` `"subdistrict"` `"district"` `"city"`
  final String localityType;

  /// Postal address of the result item.
  final Address? address;

  /// Indicates for each result how good it matches to the original query.
  ///
  /// This can be used by the customer application to accept or reject the results
  /// depending on how “expensive” is the mistake for their use case
  final Score? scoring;

  /// The bounding box enclosing the geometric shape (area or line) that an individual result covers.
  /// Place typed results have no `mapView`.
  final MapView? mapView;

  /// The coordinates (latitude, longitude) of a pin on a map corresponding to the searched place.
  final GeoPosition? position;

  /// Coordinates of the place you are navigating to (for example, driving or walking).
  /// This is a point on a road or in a parking lot.
  final List<GeoPosition?>? access;

  /// The list of categories assigned to this place.
  final List<Category?>? categories;

  /// The distance from the search center to this result item in meters.
  final int distance;

  const Geocode._({
    this.title = "",
    this.id = "",
    this.politicalView = "",
    this.resultType = "",
    this.houseNumberType = "",
    this.addressBlockType = "",
    this.localityType = "",
    this.distance = 0,
    this.address,
    this.mapView,
    this.position,
    this.scoring,
    this.categories = const [],
    this.access = const [],
  });

  factory Geocode({
    String? title = "",
    String? id = "",
    String? politicalView = "",
    String? resultType = "",
    String? houseNumberType = "",
    String? addressBlockType = "",
    String? localityType = "",
    GeoPosition? position,
    int? distance = 0,
    MapView? mapView,
    Address? address,
    Score? scoring,
    List<Category?>? categories = const [],
    List<GeoPosition?>? access = const [],
  }) =>
      Geocode._(
        title: title ?? "",
        id: id ?? "",
        politicalView: politicalView ?? "",
        resultType: resultType ?? "",
        houseNumberType: houseNumberType ?? "",
        addressBlockType: addressBlockType ?? "",
        localityType: localityType ?? "",
        distance: distance ?? 0,
        address: address,
        access: access,
        mapView: mapView,
        scoring: scoring,
        position: position,
        categories: categories,
      );

  factory Geocode.fromJson(Map<String?, dynamic>? json) {
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
      categories = [];
    } else {
      List list = json["categories"];
      categories = list.map((element) => Category.fromJson(element)).toList();
    }

    return Geocode(
      title: json?["title"] ?? "",
      id: json?["id"] ?? "",
      politicalView: json?["politicalView"] ?? "",
      resultType: json?["resultType"] ?? "",
      houseNumberType: json?["houseNumberType"] ?? "",
      addressBlockType: json?["addressBlockType"] ?? "",
      localityType: json?["localityType"] ?? "",
      address: Address.fromJson(json?["address"] ?? {}),
      mapView: MapView.fromJson(json?["mapView"] ?? {}),
      position: GeoPosition.fromJson(json?["position"] ?? {}),
      scoring: Score.fromJson(json?["scoring"] ?? {}),
      distance: json?["distance"] ?? 0,
      categories: categories,
      access: access,
    );
  }

  static Map<String, dynamic>? toJson(Geocode? geocode) {
    List<Map<String?, dynamic>?>? access;
    if (geocode == null ||
        geocode.access == null ||
        !(geocode.access is List<GeoPosition?>?) ||
        geocode.access == []) {
      access = [];
    } else {
      final list = geocode.access ?? [];
      access = list.map((element) => GeoPosition.toJson(element)).toList();
    }

    List<Map<String?, dynamic>?>? categories;
    if (geocode == null ||
        geocode.categories == null ||
        !(geocode.categories is List<Category?>?) ||
        geocode.categories == []) {
      categories = [];
    } else {
      final list = geocode.categories ?? [];
      categories = list.map((element) => Category.toJson(element)).toList();
    }

    return <String, dynamic>{
      "title": geocode?.title ?? "",
      "id": geocode?.id ?? "",
      "politicalView": geocode?.politicalView ?? "",
      "resultType": geocode?.resultType ?? "",
      "houseNumberType": geocode?.houseNumberType ?? "",
      "addressBlockType": geocode?.addressBlockType ?? "",
      "position": GeoPosition.toJson(geocode?.position),
      "localityType": geocode?.localityType ?? "",
      "mapView": MapView.toJson(geocode?.mapView),
      "address": Address.toJson(geocode?.address),
      "distance": geocode?.distance ?? 0,
      "access": access,
      "categories": categories,
      "scoring": Score.toJson(geocode?.scoring),
    };
  }

  @override
  List<Object?> get props => [
        title,
        id,
        politicalView,
        resultType,
        houseNumberType,
        addressBlockType,
        localityType,
        categories,
        distance,
        access,
        mapView,
        position,
        scoring,
      ];
}
