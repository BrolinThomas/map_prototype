import 'package:latlong2/latlong.dart';

class RouteInfo {
  final List<LatLng> routePoints;
  final double distanceInMeters;
  final double durationInSeconds;
  final String summary;
  final double averageSpeedKmh; // Average speed for the route

  const RouteInfo({
    required this.routePoints,
    required this.distanceInMeters,
    required this.durationInSeconds,
    required this.summary,
    this.averageSpeedKmh = 50.0, // Default: 50 km/h
  });

  String get formattedDistance {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    }
    return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
  }

  String get formattedDuration {
    final minutes = (durationInSeconds / 60).round();
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '$hours h $remainingMinutes min';
  }

  String get estimatedArrival {
    final now = DateTime.now();
    final arrival = now.add(Duration(seconds: durationInSeconds.toInt()));
    return '${arrival.hour.toString().padLeft(2, '0')}:${arrival.minute.toString().padLeft(2, '0')}';
  }

  /// Get updated ETA based on current speed
  String getUpdatedETA(double currentSpeedMps) {
    // If moving, use current speed; otherwise use route average
    final speedKmh = currentSpeedMps > 0.5
        ? currentSpeedMps *
              3.6 // Convert m/s to km/h
        : averageSpeedKmh;

    final distanceKm = distanceInMeters / 1000;
    final hoursRemaining = distanceKm / speedKmh;
    final secondsRemaining = (hoursRemaining * 3600).toInt();

    final arrival = DateTime.now().add(Duration(seconds: secondsRemaining));
    return '${arrival.hour.toString().padLeft(2, '0')}:${arrival.minute.toString().padLeft(2, '0')}';
  }

  /// Get updated duration based on current speed
  String getUpdatedDuration(double currentSpeedMps) {
    final speedKmh = currentSpeedMps > 0.5
        ? currentSpeedMps * 3.6
        : averageSpeedKmh;

    final distanceKm = distanceInMeters / 1000;
    final hoursRemaining = distanceKm / speedKmh;
    final minutes = (hoursRemaining * 60).round();

    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '$hours h $remainingMinutes min';
  }
}
