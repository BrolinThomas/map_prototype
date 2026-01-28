import 'package:latlong2/latlong.dart';
import '../../models/map_marker.dart';
import '../../models/proximity_zone.dart';
import '../../models/route_info.dart';

sealed class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapPermissionDenied extends MapState {}

class MapLoaded extends MapState {
  final LatLng? currentLocation;
  final List<MapMarker> markers;
  final Map<String, ProximityZone> markerProximity;
  final RouteInfo? activeRoute;
  final String? selectedMarkerId;

  MapLoaded({
    this.currentLocation,
    required this.markers,
    required this.markerProximity,
    this.activeRoute,
    this.selectedMarkerId,
  });

  MapLoaded copyWith({
    LatLng? currentLocation,
    List<MapMarker>? markers,
    Map<String, ProximityZone>? markerProximity,
    RouteInfo? activeRoute,
    String? selectedMarkerId,
    bool clearRoute = false,
    bool clearSelection = false,
  }) {
    return MapLoaded(
      currentLocation: currentLocation ?? this.currentLocation,
      markers: markers ?? this.markers,
      markerProximity: markerProximity ?? this.markerProximity,
      activeRoute: clearRoute ? null : (activeRoute ?? this.activeRoute),
      selectedMarkerId: clearSelection
          ? null
          : (selectedMarkerId ?? this.selectedMarkerId),
    );
  }
}

class MapError extends MapState {
  final String message;
  MapError(this.message);
}
