import 'dart:async';
import 'package:parking/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parking/controller/FilterControllers/preferences.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parking/screens/modalBottomSheet.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:parking/constants/constant.dart';

class CustomMarker {
  //all info from APIs
  //carParkId String, latitutde, longitude double, area String, devlopment String, availablelots int String lottypes agency String

  final MarkerId markerId; //carparkId
  late BitmapDescriptor icon;
  final LatLng position; //location
  //LatLng position = LatLng(latitude/longitude);
  //can access separately by double latitude = position.latitude;
  final InfoWindow
      infoWindow; //title(area), snippet(development), onTap(open Arjun favorite)
  final int availableLots;
  final String lotType;
  final String agency;

  CustomMarker(
      {required this.markerId,
      required this.position,
      required this.infoWindow,
      required this.availableLots,
      required this.lotType,
      required this.agency});
}

Future<CustomMarker> fetchOneCarparkData(String carparkId) async {
  final response =
      await http.get(Uri.parse('$carparkDBByIdConnect/$carparkId'));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    final LatLng location = LatLng(
      data['latitude'] as double,
      data['longitude'] as double,
    );

    final CustomMarker customMarker = CustomMarker(
      markerId: MarkerId(data['CarParkID']),
      position: location,
      infoWindow: InfoWindow(
        title: data['Development'],
        snippet: data['Area'],
      ),
      availableLots: data['AvailableLots'],
      lotType: data['LotType'],
      agency: data['Agency'],
    );

    // You can set the custom marker's icon here if needed.
    setCustomMarkerIcon(customMarker);

    return customMarker;
  } else {
    throw Exception('Failed to load car park data');
  }
}

Future<List<CustomMarker>> fetchCarparkData() async {
  //FOR LOADING FROM API SERVER
  final response = await http
      .get(Uri.parse('http://172.21.148.169:8080/api/carParkdets/getAll'));
  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON
    List<CustomMarker> customMarkers = parseCarparkData(response.body);
    for (var customMarker in customMarkers) {
      setCustomMarkerIcon(customMarker);
    }

    // Use the customMarkers list as needed
    return customMarkers;
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load carpark data');
  }
}

//FOR DIRECT FROM API
List<CustomMarker> parseCarparkData(String jsonString) {
  final parsed = json.decode(jsonString);
  final List<dynamic> carparkData = parsed;
  //print('$carparkData');
  if (settings.carparkAvailabilityFilter == 1) {
    List<CustomMarker> customMarkers = [];

    for (var data in carparkData) {
      final LatLng location = LatLng(
        (data['latitude']),
        (data['longitude']),
      );

      CustomMarker customMarker = CustomMarker(
        markerId: MarkerId(data['CarParkID']),
        position: location,
        infoWindow: InfoWindow(
          title: data['Development'],
          snippet: data['Area'],
        ),
        availableLots: data['AvailableLots'],
        lotType: data['LotType'],
        agency: data['Agency'],
      );

      // Initialize the icon field
      setCustomMarkerIcon(customMarker);

      customMarkers.add(customMarker);
    }
    return customMarkers;
  }
  if (settings.carparkAvailabilityFilter == 0) {
    if (settings.red == true &&
        settings.yellow == true &&
        settings.green == true) {
      // List<dynamic> filteredcarparkData = carparkData
      // .where((carparkData) => carparkData.availableLots < 50)
      // .map((carparkData) => carparkData as Map<String, dynamic>)
      // .toList();
      List<dynamic> filteredcarparkData = carparkData;
      //print(filteredcarparkData);
      List<CustomMarker> customMarkers = [];

      for (var data in filteredcarparkData) {
        final LatLng location = LatLng(
          (data['latitude']),
          (data['longitude']),
        );

        CustomMarker customMarker = CustomMarker(
          markerId: MarkerId(data['CarParkID']),
          position: location,
          infoWindow: InfoWindow(
            title: data['Development'],
            snippet: data['Area'],
          ),
          availableLots: data['AvailableLots'],
          lotType: data['LotType'],
          agency: data['Agency'],
        );

        // Initialize the icon field
        setCustomMarkerIcon(customMarker);

        customMarkers.add(customMarker);
      }
      return customMarkers;
    }
  }
  if (settings.red == true &&
      settings.yellow == false &&
      settings.green == false) {
    // List<dynamic> filteredcarparkData = carparkData
    // .where((carparkData) => carparkData.availableLots < 50)
    // .map((carparkData) => carparkData as Map<String, dynamic>)
    // .toList();
    List<dynamic> filteredcarparkData = carparkData;
    //print(filteredcarparkData);
    List<CustomMarker> customMarkers = [];

    for (var data in filteredcarparkData) {
      if ((data['AvailableLots']) < 50) {
        final LatLng location = LatLng(
          (data['latitude']),
          (data['longitude']),
        );

        CustomMarker customMarker = CustomMarker(
          markerId: MarkerId(data['CarParkID']),
          position: location,
          infoWindow: InfoWindow(
            title: data['Development'],
            snippet: data['Area'],
          ),
          availableLots: data['AvailableLots'],
          lotType: data['LotType'],
          agency: data['Agency'],
        );

        // Initialize the icon field
        setCustomMarkerIcon(customMarker);

        customMarkers.add(customMarker);
      }
    }
    return customMarkers;
  }
  if ((settings.green == true &&
      settings.yellow == true &&
      settings.red == false)) {
    // List<dynamic> filteredcarparkData = carparkData
    // .where((carparkData) => carparkData.availableLots >= 100)
    // .map((carparkData) => carparkData as Map<String, dynamic>)
    // .toList();
    List<dynamic> filteredcarparkData = carparkData;
    List<CustomMarker> customMarkers = [];

    for (var data in filteredcarparkData) {
      if ((data['AvailableLots']) >= 50) {
        final LatLng location = LatLng(
          (data['latitude']),
          (data['longitude']),
        );

        CustomMarker customMarker = CustomMarker(
          markerId: MarkerId(data['CarParkID']),
          position: location,
          infoWindow: InfoWindow(
            title: data['Development'],
            snippet: data['Area'],
          ),
          availableLots: data['AvailableLots'],
          lotType: data['LotType'],
          agency: data['Agency'],
        );

        // Initialize the icon field
        setCustomMarkerIcon(customMarker);

        customMarkers.add(customMarker);
      }
    }
    return customMarkers;
  }
  if ((settings.green == true &&
      settings.yellow == false &&
      settings.red == true)) {
    // List<dynamic> filteredcarparkData = carparkData
    // .where((carparkData) => carparkData.availableLots >= 100)
    // .map((carparkData) => carparkData as Map<String, dynamic>)
    // .toList();
    List<dynamic> filteredcarparkData = carparkData;
    List<CustomMarker> customMarkers = [];

    for (var data in filteredcarparkData) {
      if (((data['AvailableLots']) < 50) || ((data['AvailableLots']) >= 100)) {
        final LatLng location = LatLng(
          (data['latitude']),
          (data['longitude']),
        );

        CustomMarker customMarker = CustomMarker(
          markerId: MarkerId(data['CarParkID']),
          position: location,
          infoWindow: InfoWindow(
            title: data['Development'],
            snippet: data['Area'],
          ),
          availableLots: data['AvailableLots'],
          lotType: data['LotType'],
          agency: data['Agency'],
        );

        // Initialize the icon field
        setCustomMarkerIcon(customMarker);

        customMarkers.add(customMarker);
      }
    }
    return customMarkers;
  }
  if ((settings.yellow == true && settings.red == true)) {
    List<dynamic> filteredcarparkData = carparkData;
    //print(filteredcarparkData);

    List<CustomMarker> customMarkers = [];

    for (var data in filteredcarparkData) {
      if ((data['AvailableLots']) < 100) {
        final LatLng location = LatLng(
          (data['latitude']),
          (data['longitude']),
        );
        CustomMarker customMarker = CustomMarker(
          markerId: MarkerId(data['CarParkID']),
          position: location,
          infoWindow: InfoWindow(
            title: data['Development'],
            snippet: data['Area'],
          ),
          availableLots: data['AvailableLots'],
          lotType: data['LotType'],
          agency: data['Agency'],
        );

        // Initialize the icon field
        setCustomMarkerIcon(customMarker);

        customMarkers.add(customMarker);
      }
    }
    return customMarkers;
  }
  if (settings.green == true) {
    // List<dynamic> filteredcarparkData = carparkData
    // .where((carparkData) => carparkData.availableLots >= 100)
    // .map((carparkData) => carparkData as Map<String, dynamic>)
    // .toList();
    List<dynamic> filteredcarparkData = carparkData;
    List<CustomMarker> customMarkers = [];

    for (var data in filteredcarparkData) {
      if ((data['AvailableLots']) >= 100) {
        final LatLng location = LatLng(
          (data['latitude']),
          (data['longitude']),
        );

        CustomMarker customMarker = CustomMarker(
          markerId: MarkerId(data['CarParkID']),
          position: location,
          infoWindow: InfoWindow(
            title: data['Development'],
            snippet: data['Area'],
          ),
          availableLots: data['AvailableLots'],
          lotType: data['LotType'],
          agency: data['Agency'],
        );

        // Initialize the icon field
        setCustomMarkerIcon(customMarker);

        customMarkers.add(customMarker);
      }
    }
    return customMarkers;
  }
  if (settings.yellow == true) {
    // List<dynamic> filteredcarparkData = carparkData
    // .where((carparkData) => carparkData.availableLots >= 100)
    // .map((carparkData) => carparkData as Map<String, dynamic>)
    // .toList();
    List<dynamic> filteredcarparkData = carparkData;
    List<CustomMarker> customMarkers = [];

    for (var data in filteredcarparkData) {
      if ((data['AvailableLots']) < 100) {
        final LatLng location = LatLng(
          (data['latitude']),
          (data['longitude']),
        );

        CustomMarker customMarker = CustomMarker(
          markerId: MarkerId(data['CarParkID']),
          position: location,
          infoWindow: InfoWindow(
            title: data['Development'],
            snippet: data['Area'],
          ),
          availableLots: data['AvailableLots'],
          lotType: data['LotType'],
          agency: data['Agency'],
        );

        // Initialize the icon field
        setCustomMarkerIcon(customMarker);

        customMarkers.add(customMarker);
      }
    }
    return customMarkers;
  }
  if (settings.red == true) {
    // List<dynamic> filteredcarparkData = carparkData
    // .where((carparkData) => carparkData.availableLots >= 100)
    // .map((carparkData) => carparkData as Map<String, dynamic>)
    // .toList();
    List<dynamic> filteredcarparkData = carparkData;
    List<CustomMarker> customMarkers = [];

    for (var data in filteredcarparkData) {
      if ((data['AvailableLots']) < 50) {
        final LatLng location = LatLng(
          (data['latitude']),
          (data['longitude']),
        );

        CustomMarker customMarker = CustomMarker(
          markerId: MarkerId(data['CarParkID']),
          position: location,
          infoWindow: InfoWindow(
            title: data['Development'],
            snippet: data['Area'],
          ),
          availableLots: data['AvailableLots'],
          lotType: data['LotType'],
          agency: data['Agency'],
        );

        // Initialize the icon field
        setCustomMarkerIcon(customMarker);

        customMarkers.add(customMarker);
      }
    }
    return customMarkers;
  }
  print("No carpark data found");
  return [];
}

Future<void> setCustomMarkerIcon(CustomMarker customMarker) async {
  BitmapDescriptor? newIcon; // Declare as nullable
  if (customMarker.availableLots < 50) {
    newIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/parkRed.png");
  } else if (customMarker.availableLots < 100) {
    newIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/parkOrange.png");
  } else {
    newIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/parkGreen.png");
  }
  
  //BitmapDescriptor nullIcon = BitmapDescriptor.defaultMarker;

  Future<BitmapDescriptor> createTransparentBitmapDescriptor() async {
    final byteData = await rootBundle.load(
        'assets/transparent.png'); // Change the path to your transparent image
    final Uint8List byteList = byteData.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(byteList);
  }

  //BitmapDescriptor NAIcon = await createTransparentBitmapDescriptor();
  customMarker.icon = newIcon ?? BitmapDescriptor.defaultMarker;
}

Marker customMarkerToMarker(
    BuildContext context,
    CustomMarker customMarker,
    LocationData? currentLocation,
    void Function(List<LatLng> newCoordinates) updatePolylineCallback,
    List<LatLng> polylineCoordinates) {
  return Marker(
      markerId: customMarker.markerId,
      icon: customMarker.icon,
      position: customMarker.position,
      infoWindow: customMarker.infoWindow,
      onTap: () {
        buildModalBottomSheet(context, customMarker, currentLocation,
            updatePolylineCallback, polylineCoordinates);
      });
}

void main() {
  fetchCarparkData();
}
