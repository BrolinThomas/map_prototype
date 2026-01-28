import '../../models/map_marker.dart';
import '../../services/location_service.dart';

sealed class MapEvent {}

class MapInitialize extends MapEvent {}

class MapLocationUpdated extends MapEvent {
  final LocationUpdate locationUpdate;
  MapLocationUpdated(this.locationUpdate);
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
