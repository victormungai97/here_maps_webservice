<p align="center">
  <a href="https://developer.here.com/">
    <img alt="Here" src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/HERE_logo.svg/1200px-HERE_logo.svg.png" width="100" />
  </a>
</p>
<p align="center">here_maps_webservice</p>

[![pub package](https://img.shields.io/pub/v/here_maps_webservice.svg)](https://pub.dev/packages/here_maps_webservice)

## About 

`here_maps_webservice` provides Here Maps Web Services API wrapper that serve different purposes from search, to geocoding, to map image.

## Usage

Add `here_maps_webservice`as a dependency in your pubspec.yaml
```YAML
 dependencies:
  flutter:
    sdk: flutter
  here_maps_webservice: 1.0.2
```
Run `flutter pub get` in the terminal and import `import 'package:here_maps_webservice/here_maps.dart'`

## Available APIs
- [Geocoding](https://developer.here.com/documentation/geocoding-search-api/dev_guide/topics/endpoint-geocode-brief.html)
- [Reverse Geocoding](https://developer.here.com/documentation/geocoding-search-api/dev_guide/topics/endpoint-reverse-geocode-brief.html)
- [Geocoding Autocomplete](https://developer.here.com/documentation/geocoder-autocomplete/dev_guide/topics/quick-start-get-suggestions.html)
- [Explore Nearby Places](https://developer.here.com/documentation/examples/rest/places/explore-nearby-places)
- [Explore Popular Places](https://developer.here.com/documentation/examples/rest/places/explore-popular-places)
- [HERE Map Image](https://developer.here.com/documentation/map-image/dev_guide/topics/what-is.html)


## Generate API KEY
Go to https://developer.here.com/ and create a new account if you don't have one. Create a new project and select Freemium Plan.
Under the REST section of your project, click on Create API key.

## Example

##### Nearby Places
```DART
    import 'package:here_maps_webservice/here_maps.dart';
    import 'package:location/location.dart' as l; 
    import 'package:flutter/services.dart';
    
    var currentLocation;
    var location = new l.Location();
    List<dynamic> _nearbyPlaces=[]; 

    try {
      currentLocation = await location.getLocation();
      }on PlatformException catch (error) {
      if (error.code == 'PERMISSION_DENIED') {
        print("Permission Dennied");
      }
    }
    
    HereMaps(apiKey: "your apiKey")
          .exploreNearbyPlaces( lat: currentLocation.latitude, lon: currentLocation.longitude,offset: 10)
          .then((response) {
              setState(() {
                  _nearbyPlaces.addAll(response['results']['items']);
              });
          });

```

##### Popular Places
```DART
    import 'package:here_maps_webservice/here_maps.dart';
    import 'package:location/location.dart' as l; 
    import 'package:flutter/services.dart';
    
    var currentLocation;
    var location = new l.Location();
    List<dynamic> _explorePopularPlace = []; 

    try {
      currentLocation = await location.getLocation();
      }on PlatformException catch (error) {
      if (error.code == 'PERMISSION_DENIED') {
        print("Permission Dennied");
      }
    }
    
    HereMaps(apiKey: "your apiKey")
          .explorePopularPlaces(
              lat: currentLocation.latitude,
              lon: currentLocation.longitude,
              offset: 10)
          .then((response) {
        setState(() {
          _explorePopularPlace.addAll(response['results']['items']);
        });
      });

```

##### Geocoding Autocomplete
```DART
     import 'package:here_maps_webservice/here_maps.dart';
     
     List<dynamic> _suggestion = [];
     
     HereMaps(apiKey: "your apiKey")
           .geoCodingAutoComplete(query: "YourQuery")
           .then((response) {
         setState(() {
           _suggestion.addAll(response['suggestions']);
         });
       });
```

##### Geocoding
```DART
    import 'package:here_maps_webservice/here_maps.dart';
    
    dynamic _result;
    
    HereMaps.geoCode(
      apiKey: "your apiKey",
      unstructuredQuery: _searchController?.text ?? "",
    ).then((response) {
      print(response);
      if (response is List<Geocode>) {
        Geocode geocode = response?.first ?? null;
        Address address = geocode?.address;
        GeoPosition geoposition = geocode?.position ?? null;
        setState(() {
          this._result =
              "Title: ${geocode?.title ?? 'Missing'}\nCoordinates: ${geoposition?.latitude ?? 'null'}, ${geoposition?.longitude ?? 'null'}\nAddress: ${address?.label ?? 'Missing'}";
        });
      }
      if (response is Error) {
        setState(() {
          this._result = response.title + ": " + response.action;
        });
      }
    });
```

##### Reverse Geocoding
```DART
    import 'package:here_maps_webservice/here_maps.dart';
    import 'package:location/location.dart' as l; 
    import 'package:flutter/services.dart';
    
    var currentLocation;
    var location = new l.Location();
    dynamic _result;

    try {
      currentLocation = await location.getLocation();
      }on PlatformException catch (error) {
      if (error.code == 'PERMISSION_DENIED') {
        print("Permission Dennied");
      }
    }
    
    HereMaps.reverseGeoCode(
              apiKey: "your apiKey",
              latitude: currentLocation.latitude,
              longitude: currentLocation.longitude)
          .then((response) {
        print(response);
        if (response is List<ReverseGeocode>) {
          Address address = response?.first?.address;
          setState(() {
            this._result = address?.label ?? "";
          });
        }
        if (response is Error) {
          setState(() {
            this._result = response.title + ": " + response.action;
          });
        }
      });

```

##### Request static map image
```DART
    import 'dart:typed_data';

    import 'package:here_maps_webservice/here_maps.dart';
    import 'package:location/location.dart' as l; 
    import 'package:flutter/services.dart';
    
    var currentLocation;
    var location = new l.Location();
    dynamic _result;

    try {
      currentLocation = await location.getLocation();
      }on PlatformException catch (error) {
      if (error.code == 'PERMISSION_DENIED') {
        print("Permission Dennied");
      }
    }
    
     HereMaps.generateMapImage(
        apiKey: "your apiKey",
        latitude: currentLocation?.latitude ?? 0.0,
        longitude: currentLocation?.longitude ?? 0.0,
        queryParameters: {"z": "16", "t": "14"},
      ).then((response) {
        print(response);
        if (response is Uint8List) {
          setState(() {
            this._result = response;
          });
        }
        if (response is Error) {
          setState(() {
            this._result = response.title + ": " + response.action;
          });
        }
      });

```

## TODO
- Add all the parameters in the existing APIs
- Add tests
- Make Model class for exisitng APIs
- Add routing APIs

## Feature Requests and Issues
Please file feature requests and bugs at the [issue tracker](https://github.com/AyushBherwani1998/here_maps_webservice/issues)

## Contributing
We would love to see you contribute to here_maps_webservice. Do check out our [Contributing Guidelines](https://github.com/AyushBherwani1998/here_maps_webservice/blob/master/CONTRIBUTING.md).
