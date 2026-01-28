import 'package:latlong2/latlong.dart';
import '../../models/map_marker.dart';
import '../../models/proximity_zone.dart';

sealed class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapPermissionDenied extends MapState {}

class MapLoaded extends MapState {
  final LatLng? currentLocation;
  final List<MapMarker> markers;
  final Map<String, ProximityZone> markerProximity;

  MapLoaded({
    this.currentLocation,
    required this.markers,
    required this.markerProximity,
  });

  MapLoaded copyWith({
    LatLng? currentLocation,
    List<MapMarker>? markers,
    Map<String, ProximityZone>? markerProximity,
  }) {
    return MapLoaded(
      currentLocation: currentLocation ?? this.currentLocation,
      markers: markers ?? this.markers,
      markerProximity: markerProximity ?? this.markerProximity,
    );
  }
}

class MapError extends MapState {
  final String message;
  MapError(this.message);
}
