import 'package:equatable/equatable.dart';
import 'package:basic_utils/basic_utils.dart';

/// Thic class defines the subparameters used in building a qualified query for geocoding e.t.c
class StructuredQuery extends Equatable {
  final String? country;
  final String? state;
  final String? county;
  final String? city;
  final String? district;
  final String? street;
  final String? houseNumber;
  final String? postalCode;

  StructuredQuery({
    this.country,
    this.state,
    this.county,
    this.city,
    this.district,
    this.street,
    this.houseNumber,
    this.postalCode,
  });

  @override
  List<Object?> get props => [
        country,
        state,
        county,
        city,
        district,
        street,
        houseNumber,
        postalCode,
      ];

  bool _isStringEmpty(String? s) => StringUtils.isNullOrEmpty(s);

  @override
  String toString() {
    StringBuffer _buffer = StringBuffer();
    if (!_isStringEmpty(this.city)) _buffer.write("city=$city;");
    if (!_isStringEmpty(this.state)) _buffer.write("state=$state;");
    if (!_isStringEmpty(this.country)) _buffer.write("country=$country;");
    if (!_isStringEmpty(this.postalCode)) {
      _buffer.write("postalCode=$postalCode;");
    }
    if (!_isStringEmpty(this.county)) _buffer.write("county=$county;");
    if (!_isStringEmpty(this.district)) _buffer.write("district=$district;");
    if (!_isStringEmpty(this.street)) _buffer.write("street=$street;");
    if (!_isStringEmpty(this.houseNumber)) {
      _buffer.write("houseNumber=$houseNumber;");
    }
    String str = _buffer.toString();
    if (str.endsWith(";")) str = str.substring(0, str.length - 1);
    _buffer.clear();
    return str;
  }
}
