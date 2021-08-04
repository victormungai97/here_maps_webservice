import 'package:equatable/equatable.dart';

class Score extends Equatable {
  /// Indicates how good the input matches the returned address.
  ///
  /// It is equal to `1` if all input tokens are recognized and matched
  final double queryScore;

  /// Indicates how good the individual result fields match to the corresponding part of the query.
  ///
  /// Is included only for the result fields that are actually matched to the query.
  final FieldScore? fieldScore;

  const Score._({this.queryScore = 0.0, this.fieldScore});

  factory Score({double? queryScore = 0.0, FieldScore? fieldScore}) =>
      Score._(queryScore: queryScore ?? 0.0, fieldScore: fieldScore);

  factory Score.fromJson(Map<String?, dynamic>? json) => Score(
        queryScore: json?["queryScore"] ?? 0.0,
        fieldScore: FieldScore.fromJson(json?["fieldScore"] ?? {}),
      );

  static Map<String, dynamic>? toJson(Score? score) => {
        "queryScore": score?.queryScore ?? 0.0,
        "fieldScore": FieldScore.toJson(score?.fieldScore),
      };

  @override
  List<Object?> get props => [queryScore, fieldScore];
}

class FieldScore extends Equatable {
  /// Indicates how good the result `country name` or `ISO 3166-1 alpha-3` country code
  /// matches to the freeform or qualified input.
  final num country;

  /// Indicates how good the result `ISO 3166-1 alpha-3 country code` matches to
  /// the freeform or qualified input.
  final double countryCode;

  /// Indicates how good the result `state name` matches to the freeform or qualified input.
  final double state;

  /// Indicates how good the result city name matches to the freeform or qualified input.
  final num city;

  /// Indicates how good the result street names match to the freeform or qualified input.
  ///
  /// If the input contains multiple street names, the field score is calculated and returned for each of them individually.
  final List<dynamic>? streets;

  /// Indicates how good the result house number matches to the freeform or qualified input.
  ///
  /// It may happen, that the house number, which one is looking for, is not yet in the map data.
  ///
  /// For such cases, the `/geocode` returns the nearest known house number on the same street.
  ///
  /// This represents the numeric difference between the requested and the returned house numbers.
  final num houseNumber;

  /// Indicates how good the result postal code matches to the freeform or qualified input.
  final double postalCode;

  const FieldScore._({
    this.country = 0,
    this.countryCode = 0,
    this.state = 0.0,
    this.city = 0,
    this.streets = const [],
    this.houseNumber = 0,
    this.postalCode = 0.0,
  });

  factory FieldScore({
    num country = 0,
    double countryCode = 0.0,
    double state = 0.0,
    num city = 0,
    List<dynamic>? streets = const [],
    num houseNumber = 0,
    double postalCode = 0.0,
  }) =>
      FieldScore._(
        country: country,
        countryCode: countryCode,
        state: state,
        city: city,
        streets: streets,
        houseNumber: houseNumber,
        postalCode: postalCode,
      );

  factory FieldScore.fromJson(Map<String?, dynamic>? json) => FieldScore(
        country: json?["country"] ?? 0,
        countryCode: json?["countryCode"] ?? 0.0,
        state: json?["state"] ?? 0.0,
        city: json?["city"] ?? 0,
        streets: json?["streets"] ?? [],
        houseNumber: json?["houseNumber"] ?? 0,
        postalCode: json?["postalCode"] ?? 0,
      );

  static Map<String, dynamic>? toJson(FieldScore? fieldScore) => {
        "country": fieldScore?.country ?? 0,
        "countryCode": fieldScore?.countryCode ?? 0.0,
        "state": fieldScore?.state ?? 0.0,
        "city": fieldScore?.city ?? 0,
        "streets": fieldScore?.streets ?? [],
        "houseNumber": fieldScore?.houseNumber ?? 0,
        "postalCode": fieldScore?.postalCode ?? 0.0,
      };

  @override
  List<Object?> get props => [country, city, streets, houseNumber, postalCode];
}
