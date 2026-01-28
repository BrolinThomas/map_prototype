import 'package:latlong2/latlong.dart';

/// Demo locations for testing the app without physically moving
class DemoLocations {
  // Example: Times Square, New York
  static const timesSquare = LatLng(40.758896, -73.985130);

  // Locations at different distances from Times Square
  static const nearby200m = LatLng(40.760696, -73.985130); // ~200m north
  static const nearby400m = LatLng(40.762496, -73.985130); // ~400m north
  static const nearby700m = LatLng(40.765196, -73.985130); // ~700m north
  static const nearby1200m = LatLng(40.769696, -73.985130); // ~1200m north

  // Example: London Eye, UK
  static const londonEye = LatLng(51.503324, -0.119543);

  // Example: Eiffel Tower, Paris
  static const eiffelTower = LatLng(48.858370, 2.294481);

  // Example: Sydney Opera House, Australia
  static const sydneyOpera = LatLng(-33.856784, 151.215297);

  /// Get a list of test markers around a center point
  static List<LatLng> getTestMarkersAround(LatLng center) {
    return [
      LatLng(center.latitude + 0.002, center.longitude), // ~220m north
      LatLng(center.latitude + 0.005, center.longitude), // ~550m north
      LatLng(center.latitude + 0.009, center.longitude), // ~1000m north
      LatLng(center.latitude, center.longitude + 0.002), // ~220m east
    ];
  }

  /// Simulate a walking path (returns list of coordinates)
  static List<LatLng> getWalkingPath(LatLng start, LatLng end, int steps) {
    final path = <LatLng>[];
    for (int i = 0; i <= steps; i++) {
      final ratio = i / steps;
      final lat = start.latitude + (end.latitude - start.latitude) * ratio;
      final lng = start.longitude + (end.longitude - start.longitude) * ratio;
      path.add(LatLng(lat, lng));
    }
    return path;
  }
}
