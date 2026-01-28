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
  final double? currentHeading; // Direction user is facing (0-360)
  final double? currentSpeed; // Speed in m/s
  final List<MapMarker> markers;
  final Map<String, ProximityZone> markerProximity;
  final RouteInfo? activeRoute;
  final String? selectedMarkerId;

  MapLoaded({
    this.currentLocation,
    this.currentHeading,
    this.currentSpeed,
    required this.markers,
    required this.markerProximity,
    this.activeRoute,
    this.selectedMarkerId,
  });

  MapLoaded copyWith({
    LatLng? currentLocation,
    double? currentHeading,
    double? currentSpeed,
    List<MapMarker>? markers,
    Map<String, ProximityZone>? markerProximity,
    RouteInfo? activeRoute,
    String? selectedMarkerId,
    bool clearRoute = false,
    bool clearSelection = false,
  }) {
    return MapLoaded(
      currentLocation: currentLocation ?? this.currentLocation,
      currentHeading: currentHeading ?? this.currentHeading,
      currentSpeed: currentSpeed ?? this.currentSpeed,
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
