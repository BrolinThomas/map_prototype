import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import '../models/route_info.dart';

class RoutingService {
  final Dio _dio;

  RoutingService({Dio? dio}) : _dio = dio ?? Dio();

  /// Get route using OSRM (Open Source Routing Machine)
  /// Free, no API key required
  Future<RouteInfo?> getRoute(LatLng start, LatLng end) async {
    try {
      // OSRM public API endpoint
      final url =
          'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}';

      final response = await _dio.get(
        url,
        queryParameters: {
          'overview': 'full',
          'geometries': 'geojson',
          'steps': 'true',
        },
      );

      if (response.statusCode == 200 && response.data['code'] == 'Ok') {
        final route = response.data['routes'][0];
        final geometry = route['geometry']['coordinates'] as List;

        // Convert coordinates to LatLng
        final routePoints = geometry
            .map((coord) => LatLng(coord[1] as double, coord[0] as double))
            .toList();

        final distance = (route['distance'] as num).toDouble();
        final duration = (route['duration'] as num).toDouble();

        // Calculate average speed from route data
        final avgSpeedMps = distance / duration; // meters per second
        final avgSpeedKmh = avgSpeedMps * 3.6; // convert to km/h

        return RouteInfo(
          routePoints: routePoints,
          distanceInMeters: distance,
          durationInSeconds: duration,
          summary: 'Via ${route['legs'][0]['summary'] ?? 'main roads'}',
          averageSpeedKmh: avgSpeedKmh,
        );
      }

      return null;
    } catch (e) {
      // Error getting route
      return null;
    }
  }

  /// Alternative: Get route using OpenRouteService
  /// Requires free API key from https://openrouteservice.org/
  Future<RouteInfo?> getRouteORS(
    LatLng start,
    LatLng end, {
    String? apiKey,
  }) async {
    if (apiKey == null) {
      throw Exception('OpenRouteService requires an API key');
    }

    try {
      final url = 'https://api.openrouteservice.org/v2/directions/driving-car';

      final response = await _dio.post(
        url,
        data: {
          'coordinates': [
            [start.longitude, start.latitude],
            [end.longitude, end.latitude],
          ],
        },
        options: Options(headers: {'Authorization': apiKey}),
      );

      if (response.statusCode == 200) {
        final route = response.data['routes'][0];
        final geometry = route['geometry']['coordinates'] as List;

        final routePoints = geometry
            .map((coord) => LatLng(coord[1] as double, coord[0] as double))
            .toList();

        final summary = route['summary'];
        final distance = (summary['distance'] as num).toDouble();
        final duration = (summary['duration'] as num).toDouble();

        return RouteInfo(
          routePoints: routePoints,
          distanceInMeters: distance,
          durationInSeconds: duration,
          summary: 'Recommended route',
        );
      }

      return null;
    } catch (e) {
      // Error getting route from ORS
      return null;
    }
  }
}
