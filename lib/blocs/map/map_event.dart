import 'package:latlong2/latlong.dart';
import '../../models/map_marker.dart';

sealed class MapEvent {}

class MapInitialize extends MapEvent {}

class MapLocationUpdated extends MapEvent {
  final LatLng location;
  MapLocationUpdated(this.location);
}

class MapAddMarker extends MapEvent {
  final MapMarker marker;
  MapAddMarker(this.marker);
}

class MapRemoveMarker extends MapEvent {
  final String markerId;
  MapRemoveMarker(this.markerId);
}

class MapClearAllMarkers extends MapEvent {}

class MapGetDirections extends MapEvent {
  final String markerId;
  MapGetDirections(this.markerId);
}

class MapClearDirections extends MapEvent {}
