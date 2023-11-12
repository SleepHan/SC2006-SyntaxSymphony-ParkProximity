import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:parking/controller/markers.dart';
import 'package:parking/constants/constant.dart';

void getPolyPoints(CustomMarker customMarker, LocationData? currentLocation,
    void Function(List<LatLng> newCoordinates) updateCallback) async {
  try {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(currentLocation?.latitude ?? 0.0,
            currentLocation?.longitude ?? 0.0),
        PointLatLng(
            customMarker.position.latitude, customMarker.position.longitude));

    if (result.points.isNotEmpty) {
      List<LatLng> newCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      updateCallback(newCoordinates);
    }
  } catch (e) {
    print('Error while fetching polyline points: $e');
  }
}
