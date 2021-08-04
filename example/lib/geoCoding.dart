import 'package:flutter/material.dart';
import 'package:here_maps_webservice/here_maps_webservice.dart';

import 'utils.dart';

class GeoCoding extends StatefulWidget {
  @override
  _GeoCodingState createState() => _GeoCodingState();
}

class _GeoCodingState extends State<GeoCoding> {
  dynamic _result;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.addListener(() {
      final text = _searchController.text;
      _searchController.value = _searchController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GeoCoding"),
      ),
      body: Column(
        children: <Widget>[
          getSearchBar(),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: _result == null
                  ? Text("Waiting for results...")
                  : _result is String
                      ? Text(_result)
                      : _result is GeoPosition
                          ? Text("${_result.latitude},${_result.longitude}")
                          : Text("No Results"),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                getGeoCode();
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(24),
              color: Colors.blueAccent,
              width: MediaQuery.of(context).size.width,
              child: Text(
                "GeoCode",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }

  getSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.all(Radius.circular(32)),
        child: TextField(
          controller: _searchController,
          onChanged: ((value) {
            setState(() {
              _searchController.text = value;
            });
            print(_searchController.text);
          }),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.blue,
            ),
            hintText: "Geocode Query",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.0),
                borderRadius: BorderRadius.all(Radius.circular(0))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.0),
                borderRadius: BorderRadius.all(Radius.circular(0))),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  void getGeoCode() {
    HereMaps.geoCode(
      apiKey: API_KEY,
      unstructuredQuery: _searchController?.text ?? "",
    ).then((response) {
      print(response);
      if (response is List<Geocode>) {
        Geocode geocode = response?.first ?? null;
        Address address = geocode?.address;
        if (address == null) {
          showToast("No address found at given coordinated");
        }
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
  }
}
