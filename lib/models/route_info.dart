import 'package:latlong2/latlong.dart';

class RouteInfo {
  final List<LatLng> routePoints;
  final double distanceInMeters;
  final double durationInSeconds;
  final String summary;

  const RouteInfo({
    required this.routePoints,
    required this.distanceInMeters,
    required this.durationInSeconds,
    required this.summary,
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
}
