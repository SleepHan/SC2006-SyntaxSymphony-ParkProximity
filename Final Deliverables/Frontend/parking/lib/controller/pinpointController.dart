import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/widgets/pinpointParked.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:parking/constants/constant.dart';

class PinPointController {
  Future<void> showPinpointForm(BuildContext context, String carParkId) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: PinPointParked(carParkId: carParkId));
        });
  }

  Future<void> showDeleteForm(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Remove current parked location?'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('No'),
                onPressed: () {
                  print("NO");
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _deleteParkedLocation();
                  Navigator.pop(context);
                },
                child: Text('Yes'),
              )
            ],
          );
        });
  }

  Future<List<double>> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double long = position.longitude, lat = position.latitude;
    return [long, lat];
  }

  void processSubmission(
      String notes, String carParkId, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<double> coordinates = await _getLocation();
    print('Notes: $notes');
    print('Longitude: ${coordinates[0]}');
    print('Latitude: ${coordinates[1]}');

    final response = await _createParkedLocation(
        coordinates[1], coordinates[0], notes, carParkId);

    if (response.statusCode == 200) {
      prefs.setBool('Parked', true);
    }
  }

  Future<http.Response> _createParkedLocation(
      double lat, double long, String notes, String carParkId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userID = pref.getString('User ID') as String;
    pref.setDouble('Lat', lat);
    pref.setDouble('Long', long);
    pref.setString('Notes', notes);

    return http.post(
      Uri.parse('$parkedConnect/$userID/$carParkId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'longitude': long,
        'latitude': lat,
        'notes': notes
      }),
    );
  }

  Future<http.Response> _getParkedLocation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userID = pref.getString('User ID') as String;

    return http.get(
      Uri.parse('$parkedConnect/$userID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> _deleteParkedLocation() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userID = pref.getString('User ID') as String;
    pref.remove('Lat');
    pref.remove('Long');
    pref.remove('Notes');

    http.Response response = await http.delete(
      Uri.parse('$parkedConnect/$userID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      pref.setBool('Parked', false);
    }

    return response;
  }

  Future<bool> parkedSet() async {
    http.Response response = await _getParkedLocation();
    var responseBody = jsonDecode(response.body);
    print(responseBody.toString());

    if (responseBody != null) {
      return true;
    } else {
      return false;
    }
  }
}
