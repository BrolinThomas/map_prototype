import 'dart:ui';

enum ProximityZone {
  farAway(1000, Color(0xFF4CAF50)), // Green
  approaching(500, Color(0xFFFFEB3B)), // Yellow
  near(200, Color(0xFFFF9800)), // Orange
  veryClose(0, Color(0xFFF44336)); // Red

  final double threshold; // minimum distance in meters
  final Color color;

  const ProximityZone(this.threshold, this.color);

  static ProximityZone fromDistance(double distance) {
    if (distance < 200) return ProximityZone.veryClose;
    if (distance < 500) return ProximityZone.near;
    if (distance < 1000) return ProximityZone.approaching;
    return ProximityZone.farAway;
  }
}
