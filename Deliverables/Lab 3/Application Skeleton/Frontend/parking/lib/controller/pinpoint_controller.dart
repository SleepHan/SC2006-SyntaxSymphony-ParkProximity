import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parking/widgets/pinpoint_parked.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:parking/constants/constant.dart';


class PinPointController {
  Future<void> showPinpointForm(BuildContext context) async {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog (
          content: PinPointParked()
        );
      }
    );
  }

  Future<void> showDeleteForm(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Remove current parked location?'),
          actions: <Widget> [
            ElevatedButton (
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
      }
    );
  }

  Future<List<String>> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    String long = position.longitude.toString(), lat = position.latitude.toString();
    return [long, lat];
  }

  void processSubmission(String notes) async {
    List<String> coordinates = await _getLocation();
    print('Notes: $notes');
    print('Longitude: ${coordinates[0]}');
    print('Latitude: ${coordinates[1]}');

    final response = await _createParkedLocation(coordinates[1], coordinates[0], notes);

    print(response.statusCode);
  }

  Future<http.Response> _createParkedLocation(String lat, String long, String notes) {
    return http.post(
      Uri.parse('$parkedConnect/4'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String> {
        'longitude': long,
        'latitude': lat,
        'notes': notes
      }),
    );
  }

  Future<http.Response> _getParkedLocation() async {
    return http.get(
      Uri.parse('$parkedConnect/4'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<http.Response> _deleteParkedLocation() async {
    return http.delete(
      Uri.parse('$parkedConnect/4'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<bool> parkedSet() async {
    http.Response response = await _getParkedLocation();
    var responseBody = jsonDecode(response.body);
    print(responseBody.toString());

    if (responseBody != null) { return true; }
    else { return false; }
  }
}