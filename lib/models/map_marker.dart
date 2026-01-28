import 'package:latlong2/latlong.dart';

class MapMarker {
  final String id;
  final LatLng position;
  final double radius; // in meters
  final String? label;

  const MapMarker({
    required this.id,
    required this.position,
    required this.radius,
    this.label,
  });

  MapMarker copyWith({
    String? id,
    LatLng? position,
    double? radius,
    String? label,
  }) {
    return MapMarker(
      id: id ?? this.id,
      position: position ?? this.position,
      radius: radius ?? this.radius,
      label: label ?? this.label,
    );
  }
}
