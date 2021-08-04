import 'package:equatable/equatable.dart';

class Address extends Equatable {
  /// Assembled address value built out of the address components according to the regional postal rules.
  /// These are the same rules for all endpoints.
  /// It may not include all the input terms.
  final String label;

  /// Three-letter country code.
  final String countryCode;

  /// Localised country name.
  final String countryName;

  /// State code or state name abbreviation – country specific
  final String stateCode;

  /// State division of a country.
  final String state;

  /// Division of a state; typically, a secondary-level administrative division of a country or equivalent.
  final String county;

  /// Name of the primary locality of the place.
  final String city;

  /// Division of city; typically an administrative unit within a larger city or a customary name of a city's neighborhood.
  final String district;

  /// Name of street.
  final String street;

  /// Alphanumeric string included in a postal address to facilitate mail sorting, such as post code, postcode, or ZIP code.
  final String postalCode;

  /// House number.
  final String houseNumber;

  const Address._({
    this.label = "",
    this.countryCode = "",
    this.countryName = "",
    this.stateCode = "",
    this.state = "",
    this.county = "",
    this.city = "",
    this.district = "",
    this.street = "",
    this.postalCode = "",
    this.houseNumber = "",
  });

  factory Address({
    String? label = "",
    String? countryCode = "",
    String? countryName = "",
    String? stateCode = "",
    String? state = "",
    String? county = "",
    String? city = "",
    String? district = "",
    String? street = "",
    String? postalCode = "",
    String? houseNumber = "",
  }) =>
      Address._(
        label: label ?? "",
        countryCode: countryCode ?? "",
        countryName: countryName ?? "",
        stateCode: stateCode ?? "",
        state: state ?? "",
        county: county ?? "",
        city: city ?? "",
        district: district ?? "",
        street: street ?? "",
        postalCode: postalCode ?? "",
        houseNumber: houseNumber ?? "",
      );

  factory Address.fromJson(Map<String?, dynamic>? json) => Address(
        label: json?["label"] ?? "",
        countryCode: json?["countryCode"] ?? "",
        countryName: json?["countryName"] ?? "",
        stateCode: json?["stateCode"] ?? "",
        state: json?["state"] ?? "",
        county: json?["county"] ?? "",
        city: json?["city"] ?? "",
        district: json?["district"] ?? "",
        street: json?["street"] ?? "",
        postalCode: json?["postalCode"] ?? "",
        houseNumber: json?["houseNumber"] ?? "",
      );

  static Map<String, dynamic>? toJson(Address? address) => <String, dynamic>{
        "label": address?.label ?? "",
        "countryCode": address?.countryCode ?? "",
        "countryName": address?.countryName ?? "",
        "stateCode": address?.stateCode ?? "",
        "state": address?.state ?? "",
        "county": address?.county ?? "",
        "city": address?.city ?? "",
        "district": address?.district ?? "",
        "street": address?.street ?? "",
        "postalCode": address?.postalCode ?? "",
        "houseNumber": address?.houseNumber ?? "",
      };

  @override
  List<Object?> get props => [
        label,
        countryCode,
        countryName,
        stateCode,
        state,
        county,
        city,
        district,
        street,
        postalCode,
        houseNumber,
      ];
}
