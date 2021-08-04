import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:here_maps_webservice/here_maps_webservice.dart';
import 'package:location/location.dart' as l;
import 'package:flutter/services.dart';

import 'utils.dart';

class HereMapImage extends StatefulWidget {
  @override
  _HereMapImageState createState() => _HereMapImageState();
}

class _HereMapImageState extends State<HereMapImage> {
  var currentLocation;
  dynamic result = '';
  @override
  void initState() {
    getHereMapImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get HERE Map Image"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text(currentLocation != null
                ? "${currentLocation.latitude},${currentLocation.longitude}"
                : "Loading"),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.all(24),
              alignment: Alignment.center,
              child: result == null
                  ? Text("Loading")
                  : (result is String)
                      ? Text(result)
                      : (result is Uint8List)
                          ? Image.memory(result)
                          : Placeholder()),
        ],
      ),
    );
  }

  void getHereMapImage() async {
    var location = new l.Location();

    try {
      await location.getLocation().then((location) {
        print(location);
        setState(() {
          currentLocation = location;
        });
      });
      HereMaps.generateMapImage(
        apiKey: API_KEY,
        latitude: currentLocation?.latitude ?? 0.0,
        longitude: currentLocation?.longitude ?? 0.0,
        queryParameters: {"i": "1", "pip": null},
      ).then((response) {
        print(response);
        if (response is Uint8List) {
          setState(() {
            this.result = response;
          });
        }
        if (response is Error) {
          setState(() {
            this.result = response.title + ": " + response.action;
          });
        }
      });
    } on PlatformException catch (error) {
      if (error.code == 'PERMISSION_DENIED') {
        print("Permission Dennied");
      }
    }
  }
}
