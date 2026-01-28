import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationUpdate {
  final LatLng position;
  final double? heading; // Direction user is facing (0-360 degrees)
  final double? speed; // Speed in m/s

  const LocationUpdate({required this.position, this.heading, this.speed});
}

class LocationService {
  Stream<LocationUpdate> getLocationStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Update every 5 meters for smoother navigation
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings).map(
      (position) => LocationUpdate(
        position: LatLng(position.latitude, position.longitude),
        heading: position.heading >= 0 ? position.heading : null,
        speed: position.speed,
      ),
    );
  }

  Future<LocationUpdate?> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      return LocationUpdate(
        position: LatLng(position.latitude, position.longitude),
        heading: position.heading >= 0 ? position.heading : null,
        speed: position.speed,
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    const distance = Distance();
    return distance.as(LengthUnit.Meter, point1, point2);
  }

  /// Calculate bearing/heading from point1 to point2 (in degrees)
  double calculateBearing(LatLng from, LatLng to) {
    const distance = Distance();
    return distance.bearing(from, to);
  }
}
