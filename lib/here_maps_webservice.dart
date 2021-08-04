library here_maps;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:basic_utils/basic_utils.dart';

import 'package:here_maps_webservice/models/models.dart';

export 'package:here_maps_webservice/models/models.dart';

/// [apiKey] can be obtained from the REST section
/// given under the Freemium Projects

class HereMaps {
  final String apiKey;

  HereMaps({required this.apiKey});

  /// exploreNearbyPlaces returns a List of places near the center of the [lat] and [lon] given
  /// [offset] can be given to set the number of results returned by exploreNearbyPlaces
  /// By default the value of [offset] is set to 20
  /// [nextUrl] can be given to fetch the next set of results

  Future<Map<String, dynamic>?> exploreNearbyPlaces(
      {required double lat,
      required double lon,
      int offset = 20,
      String? nextUrl}) async {
    assert(offset >= 0, "offset can't be negative");

    var _headers = {
      "Accept": "application/json",
    };

    Map<String, String> body = Map();
    body["at"] = '$lat,$lon';
    body['size'] = offset.toString();
    body["apiKey"] = this.apiKey;
    body["tf"] = "plain";

    var uri =
        Uri.https('places.ls.hereapi.com', '/places/v1/discover/here', body);
    return makeApiCall(nextUrl ?? uri, _headers);
  }

  /// exploreNearbyPlaces returns a List of popular places near the center of the [lat] and [lon] given
  /// [category] can be given to retrieve the popular places of particular [category]
  /// [offset] can be given to set the number of results returned by exploreNearbyPlaces
  /// By default the value of [offset] is set to 20
  /// [nextUrl] can be given to fetch the next set of results

  Future<Map<String, dynamic>?> explorePopularPlaces(
      {required double lat,
      required double lon,
      Categories? category,
      int offset = 20,
      String? nextUrl}) async {
    assert(offset >= 0, "offset can't be negative");

    Map<String, String> categoryMap = {
      "eatAndDrink": "eat-drink",
      "goingOut": "going-out",
      "sightsMuseums": "sights-museums",
      "atmBankExchange": "atm-bank-exchange",
      "petrolStation": "petrol-station"
    };

    String? cat;
    if (category != null) {
      cat = category.toString().substring(category.toString().indexOf('.') + 1);
    }
    var _headers = {
      "Accept": "application/json",
    };

    Map<String, String?> body = Map();
    body["at"] = '$lat,$lon';
    if (cat != null)
      body['cat'] = categoryMap.containsKey(cat) ? categoryMap[cat] : cat;
    body['size'] = offset.toString();
    body["apiKey"] = this.apiKey;
    body["tf"] = "plain";

    var uri =
        Uri.https('places.ls.hereapi.com', '/places/v1/discover/explore', body);
    return makeApiCall(nextUrl ?? uri, _headers);
  }

  /// geoCodingAutoComplete provides better results for address searches with fewer keystrokes
  /// [query] is the mandatory parameter. The Results is returned on the basis of [query]
  /// [maxResults] can be given to restrict the suggestions based on [query]
  /// The valid value of [maxResults] is between 1 to 10

  Future<Map<String, dynamic>?> geoCodingAutoComplete(
      {required String query, int maxResults = 1}) async {
    assert(maxResults >= 1 && maxResults <= 10,
        "maxResults must be between 1 and 10");
    var _headers = {
      "Accept": "application/json",
    };
    Map<String, String> data = Map();
    data["query"] = query;
    data["apiKey"] = this.apiKey;
    data['maxResults'] = '$maxResults';

    var uri = Uri.https(
        'autocomplete.geocoder.ls.hereapi.com', '/6.2/suggest.json', data);
    return makeApiCall(uri, _headers);
  }

  /// geoCode can be used to find geo-coordinates
  /// and complete postal address string and address details of a known place
  /// based on provided query
  ///
  /// [apiKey] is required and can be obtained from the REST section given under the Freemium Projects.
  ///
  /// [center] specifies the center of the search context as latitude/longitude
  ///
  /// [unstructuredQuery] defines a free-text query
  ///
  /// [structuredQuery] defines a qualified query.
  /// A qualified query is similar to a free-text query, but in a structured manner
  /// It's required subparameters are defined in the constructor
  ///
  /// Either [unstructuredQuery] or [structuredQuery] is required.
  /// Both parameters can be provided in the same request.
  ///
  /// [language] will be used for result rendering and should be selected from a list of `BCP 47` compliant language codes..
  ///
  /// [maxResults], if specified, defines the maximum number of results to be returned.

  static Future<dynamic>? geoCode({
    required String? apiKey,
    String? language,
    GeoPosition? center,
    int? maxResults = 20,
    String? unstructuredQuery,
    StructuredQuery? structuredQuery,
  }) async {
    try {
      if (StringUtils.isNullOrEmpty(apiKey)) {
        return Error(
          status: 500,
          title: "Illegal input for parameter 'apiKey'",
          action: "API Key should not be empty",
          cause: "Actual parameter value: '$apiKey'",
        );
      }

      if (StringUtils.isNullOrEmpty(unstructuredQuery) &&
          (structuredQuery == null ||
              StringUtils.isNullOrEmpty(structuredQuery.toString()))) {
        return Error(
          status: 500,
          title:
              "Required parameter missing. At least one of 'unstructuredQuery' or 'structuredQuery' needs to be present",
          action:
              "Either 'unstructuredQuery' or 'structuredQuery' should be present",
        );
      }

      Map<String, dynamic> _queryParameters = <String, dynamic>{
        "apiKey": apiKey
      };

      if (StringUtils.isNotNullOrEmpty(unstructuredQuery)) {
        _queryParameters["q"] = unstructuredQuery;
      }

      if (structuredQuery != null &&
          StringUtils.isNotNullOrEmpty(structuredQuery.toString())) {
        _queryParameters["qq"] = structuredQuery.toString();
      }

      if (StringUtils.isNotNullOrEmpty(language)) {
        _queryParameters["lang"] = language;
      }

      if (maxResults != null) _queryParameters["limit"] = "$maxResults";

      if (center != null) {
        _queryParameters["at"] = "${center.latitude},${center.longitude}";
      }

      Uri uri = Uri(
        scheme: "https",
        host: "geocode.search.hereapi.com",
        path: "/v1/geocode",
        queryParameters: _queryParameters,
      );

      var response = await http.get(uri);
      final statusCode = response.statusCode;

      if (statusCode == 200) {
        Map? result = json.decode(response.body);
        if (result == null) {
          return Error(
            status: statusCode,
            title: "Geocoding Error",
            action: "No response found for given query/queries",
          );
        }
        List? items = result["items"];
        if (items == null || !(items is List) || items.isEmpty) {
          return Error(
            status: statusCode,
            title: "Geocoding Error",
            action: "No place found for given query/queries",
          );
        }
        return items.map((json) => Geocode.fromJson(json)).toList();
      } else if (statusCode == 400 || statusCode == 405 || statusCode == 503) {
        return Error.fromJson(json.decode(response.body));
      } else if (statusCode == 401) {
        Map result = json.decode(response.body) ?? {};
        return Error(
          status: statusCode,
          title: result["error"] ?? "Unauthorized",
          action: result["error_description"] ?? "Authorization error",
        );
      } else {
        return Error(
          status: statusCode,
          title: "Geocoding Error",
          action: "${response.body}",
        );
      }
    } catch (ex) {
      return Error(
        status: 500,
        title: "Geocoding Exception",
        action: "Error encountered while carrying out geocoding\n$ex",
      );
    }
  }

  /// reverseGeoCode retrieves the nearest address to specified geo coordinates.
  ///
  /// [latitude] and [longitude] define the center of the search context expressed as coordinates.
  ///
  /// [apiKey] can be obtained from the REST section given under the Freemium Projects.
  ///
  /// [maxResults], if specified, defines the maximum number of results to be returned.
  ///
  /// [language] will be used for result rendering and should be selected from a list of `BCP 47` compliant language codes..
  ///
  /// [radius]. if specified, defines a geographical circular area within which search is done. It should be in meters.
  ///
  /// More on this at https://developer.here.com/documentation/geocoding-search-api/api-reference-swagger.html

  static Future<dynamic>? reverseGeoCode({
    required double? latitude,
    required double? longitude,
    required String? apiKey,
    int? maxResults = 1,
    String? language,
    int? radius,
  }) async {
    try {
      if (latitude == null) {
        return Error(
          status: 500,
          title: "Illegal input for parameter 'latitude'",
          action: "Latitude should not be null",
          cause: "Actual parameter value: '$latitude'",
        );
      }
      if (longitude == null) {
        return Error(
          status: 500,
          title: "Illegal input for parameter 'longitude'",
          action: "Longitude should not be null",
          cause: "Actual parameter value: '$longitude'",
        );
      }
      if (StringUtils.isNullOrEmpty(apiKey)) {
        return Error(
          status: 500,
          title: "Illegal input for parameter 'apiKey'",
          action: "API Key should not be empty",
          cause: "Actual parameter value: '$apiKey'",
        );
      }
      if (maxResults == null) maxResults = 1;
      if (maxResults < 1 || maxResults > 100) {
        return Error(
          status: 500,
          title: "Illegal input for parameter 'maxResults'",
          action: "Should be an integer in the range of [1,100]",
          cause: "Actual parameter value: '$maxResults'",
        );
      }
      if (radius != null && radius < 1) {
        return Error(
          status: 500,
          title: "Illegal input for parameter 'radius'",
          action: "requirement failed: Circle radius should be greater than 0",
          cause: "Actual parameter value: '$radius'",
        );
      }

      final lang = (language == null || language.isEmpty) ? "en-US" : language;

      Map<String, dynamic> _queryParameters = <String, dynamic>{
        "lang": lang,
        "apiKey": apiKey,
        "limit": "$maxResults",
      };

      if (radius == null) {
        _queryParameters["at"] = "$latitude,$longitude";
      } else {
        _queryParameters["in"] = "circle:$latitude,$longitude;r=$radius";
      }

      Uri uri = Uri(
        scheme: "https",
        host: "revgeocode.search.hereapi.com",
        path: "/v1/revgeocode",
        queryParameters: _queryParameters,
      );

      var response = await http.get(uri);
      final statusCode = response.statusCode;

      if (statusCode == 200) {
        Map? result = json.decode(response.body);
        if (result == null) {
          return Error(
            status: statusCode,
            title: "Reverse Geocoding Error",
            action: "No response found for given coordinates",
          );
        }
        List? items = result["items"];
        if (items == null || !(items is List) || items.isEmpty) {
          return Error(
            status: statusCode,
            title: "Reverse Geocoding Error",
            action: "No place found for given coordinates",
          );
        }
        return items.map((json) => ReverseGeocode.fromJson(json)).toList();
      } else if (statusCode == 400 || statusCode == 405 || statusCode == 503) {
        return Error.fromJson(json.decode(response.body));
      } else if (statusCode == 401) {
        Map result = json.decode(response.body) ?? {};
        return Error(
          status: statusCode,
          title: result["error"] ?? "Unauthorized",
          action: result["error_description"] ?? "Authorization error",
        );
      } else {
        return Error(
          status: statusCode,
          title: "Reverse Geocoding Error",
          action: "${response.body}",
        );
      }
    } catch (ex) {
      return Error(
        status: 500,
        title: "Reverse Geocoding Exception",
        action: "Error encountered while carrying out reverse geocoding\n$ex",
      );
    }
  }

  /// generateMapImage builds a static map using HERE Map Image API.
  ///
  /// [latitude] and [longitude] define the center of the search context expressed as coordinates.
  ///
  /// [apiKey] can be obtained from the REST section given under the Freemium Projects.
  ///
  /// [width], [height] and [zoom] can be left out and defaults are used.
  ///
  /// Additional parameters can be passed accordingly.
  ///
  /// If api call was successful, result will be returned as image bytes.
  ///
  /// In case you have an address in place of coordinates, you can use [geoCode]
  /// to convert it to lat/lon and then build map image.
  ///
  /// Visit https://developer.here.com/blog/migrating-from-google-static-maps for a detailed guide.

  static Future<dynamic>? generateMapImage({
    required String? apiKey,
    required double? latitude,
    required double? longitude,
    int? width,
    int? height,
    int? zoom,
    Map<String, String?>? queryParameters,
  }) async {
    try {
      if (latitude == null) {
        return Error(
          title: "Illegal input for parameter 'latitude'",
          action: "Latitude should not be null",
        );
      }
      if (longitude == null) {
        return Error(
          title: "Illegal input for parameter 'longitude'",
          action: "Longitude should not be null",
        );
      }
      if (apiKey == null || apiKey.isEmpty) {
        return Error(
          title: "Illegal input for parameter 'apiKey'",
          action: "API Key should not be empty",
        );
      }

      Map<String, String?> _queryParameters = <String, String?>{
        "apiKey": apiKey,
        "c": "$latitude,$longitude",
      };

      if (width != null) _queryParameters["w"] = '$width';

      if (height != null) _queryParameters["h"] = '$height';

      if (zoom != null) _queryParameters["z"] = '$zoom';

      if (queryParameters != null && queryParameters.isNotEmpty) {
        queryParameters.addAll(_queryParameters);
      } else {
        queryParameters = _queryParameters;
      }

      Uri uri = Uri(
        scheme: "https",
        host: "image.maps.ls.hereapi.com",
        path: "/mia/1.6/mapview",
        queryParameters: queryParameters,
      );

      var response = await http.get(uri);
      final statusCode = response.statusCode;

      if (statusCode == 200) {
        return response.bodyBytes;
      } else if (statusCode == 401) {
        Map result = json.decode(response.body) ?? {};
        return Error(
          status: statusCode,
          title: result["error"] ?? "Unauthorized",
          action: result["error_description"] ?? "Authorization error",
        );
      } else {
        return Error(
          status: statusCode,
          title: "HERE Map Image Error",
          action: "${response.body}",
        );
      }
    } catch (ex) {
      return Error(
        status: 500,
        title: "HERE Map Image Exception",
        action: "Error encountered while getting HERE Map Image\n$ex",
      );
    }
  }
}

/// Categories for explorePopularPlaces
enum Categories {
  eatAndDrink,
  goingOut,
  sightsMuseums,
  transport,
  accommodation,
  shopping,
  atmBankExchange,
  hospital,
  petrolStation
}

/// Modes for ReverseGeoCode
enum ReverseGeoCodeModes {
  retrieveAddresses,
  retrieveAreas,
  retrieveLandmarks,
  retrieveAll,
  trackPosition
}

Future<Map<String, dynamic>?> makeApiCall(dynamic uri, Map headers) async {
  http.Response response =
      await http.get(uri, headers: headers as Map<String, String>?);
  return json.decode(response.body);
}
