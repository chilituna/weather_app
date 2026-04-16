// handles GPS and location permissions
import 'package:geolocator/geolocator.dart';

class LocationService {

  Future<Position> getCurrentLocation() async {

    // 1. check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // 2. check location permissions. Request permissions if not granted.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, please enable them in settings.');
    }

    // 3. fetch the current location
      return await Geolocator.getCurrentPosition();
  }
}