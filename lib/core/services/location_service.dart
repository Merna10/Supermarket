import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> getAddressFromLatLng(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
  }

  Future<bool> isDeliveryAvailable(String address) async {
    try {
      // Convert address to position
      List<Location> locations = await locationFromAddress(address);
      if (locations.isEmpty) {
        return false; // No locations found for the address
      }

      Position position = Position(
        latitude: locations.first.latitude,
        longitude: locations.first.longitude,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );

      // Fetch placemark from position
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isEmpty) {
        return false; // No placemarks found for the position
      }
      
      Placemark place = placemarks[0];
      return place.country?.toLowerCase() == 'egypt';
    } catch (e) {
      print('Error in isDeliveryAvailable: $e');
      return false; // Handle any errors by assuming delivery is not available
    }
  }

  Future<Position> getCoordinatesFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    return Position(
      latitude: locations.first.latitude,
      longitude: locations.first.longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }
}
