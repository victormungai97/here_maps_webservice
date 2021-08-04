import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// TODO Provide your Here Maps API Key
const API_KEY = '';

showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: Colors.blueGrey[700],
    timeInSecForIosWeb: 1,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
