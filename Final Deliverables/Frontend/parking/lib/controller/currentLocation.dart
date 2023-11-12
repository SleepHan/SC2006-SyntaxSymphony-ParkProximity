import 'package:location/location.dart';

Future<LocationData?> getCurrentLocation() async {
  Location location = Location();
  try {
    LocationData locationData = await location.getLocation();
    return locationData;
  } catch (e) {
    print('Error getting location: $e');
    return null;
  }
}
