import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double calculateDistance(LatLng start, LatLng end) {
  const double earthRadius = 6371.0; // Radius of the Earth in kilometers

  // Convert latitude and longitude from degrees to radians
  final double startLatRad = start.latitude * (pi / 180.0);
  final double startLngRad = start.longitude * (pi / 180.0);
  final double endLatRad = end.latitude * (pi / 180.0);
  final double endLngRad = end.longitude * (pi / 180.0);

  // Haversine formula
  final double dLat = endLatRad - startLatRad;
  final double dLng = endLngRad - startLngRad;
  final double a = pow(sin(dLat / 2), 2) +
      cos(startLatRad) * cos(endLatRad) * pow(sin(dLng / 2), 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final double distance = earthRadius * c; // Distance in kilometers

  return distance;
}

// void main() {
//   LatLng point1 = LatLng(52.5200, 13.4050); // Berlin, Germany
//   LatLng point2 = LatLng(48.8566, 2.3522);  // Paris, France

//   double distance = calculateDistance(point1, point2);
//   print('Distance: $distance kilometers');
// }
