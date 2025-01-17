import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:here_maps_webservice/here_maps_webservice.dart';
import 'package:location/location.dart' as l;
import 'package:flutter/services.dart';

import 'utils.dart';

class ReverseGeoCoding extends StatefulWidget {
  @override
  _ReverseGeoCodingState createState() => _ReverseGeoCodingState();
}

class _ReverseGeoCodingState extends State<ReverseGeoCoding> {
  var currentLocation;
  String address;
  @override
  void initState() {
    doReverseGeoCoding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reverse GeoCoding"),
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
            child: Text(address ?? "Loading"),
          )
        ],
      ),
    );
  }

  void doReverseGeoCoding() async {
    var location = new l.Location();

    try {
      await location.getLocation().then((location) {
        print(location);
        setState(() {
          currentLocation = location;
        });
      });
      HereMaps.reverseGeoCode(
              apiKey: API_KEY,
              latitude: currentLocation.latitude,
              longitude: currentLocation.longitude)
          .then((response) {
        print(response);
        if (response is List<ReverseGeocode>) {
          Address address = response?.first?.address;
          if (address == null) {
            showToast("No address found at given coordinated");
          }
          setState(() {
            this.address = address?.label ?? "";
          });
        }
        if (response is Error) {
          setState(() {
            this.address = response.title + ": " + response.action;
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
