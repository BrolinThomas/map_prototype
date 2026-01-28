import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/map_marker.dart';
import '../../models/proximity_zone.dart';
import '../../services/location_service.dart';
import '../../services/routing_service.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationService locationService;
  final RoutingService routingService;
  StreamSubscription? _locationSubscription;

  MapBloc(this.locationService, this.routingService) : super(MapInitial()) {
    on<MapInitialize>(_onInitialize);
    on<MapLocationUpdated>(_onLocationUpdated);
    on<MapAddMarker>(_onAddMarker);
    on<MapRemoveMarker>(_onRemoveMarker);
    on<MapClearAllMarkers>(_onClearAllMarkers);
    on<MapGetDirections>(_onGetDirections);
    on<MapClearDirections>(_onClearDirections);
  }

  Future<void> _onInitialize(
    MapInitialize event,
    Emitter<MapState> emit,
  ) async {
    emit(MapLoading());

    final hasPermission = await locationService.requestPermission();
    if (!hasPermission) {
      emit(MapPermissionDenied());
      return;
    }

    final currentLocation = await locationService.getCurrentLocation();
    emit(
      MapLoaded(
        currentLocation: currentLocation,
        markers: [],
        markerProximity: {},
      ),
    );

    _locationSubscription = locationService.getLocationStream().listen(
      (location) => add(MapLocationUpdated(location)),
    );
  }

  void _onLocationUpdated(MapLocationUpdated event, Emitter<MapState> emit) {
    if (state is! MapLoaded) return;

    final currentState = state as MapLoaded;
    final markerProximity = <String, ProximityZone>{};

    for (final marker in currentState.markers) {
      final distance = locationService.calculateDistance(
        event.location,
        marker.position,
      );
      markerProximity[marker.id] = ProximityZone.fromDistance(distance);
    }

    emit(
      currentState.copyWith(
        currentLocation: event.location,
        markerProximity: markerProximity,
      ),
    );
  }

  void _onAddMarker(MapAddMarker event, Emitter<MapState> emit) {
    if (state is! MapLoaded) return;

    final currentState = state as MapLoaded;
    final updatedMarkers = List<MapMarker>.from(currentState.markers)
      ..add(event.marker);

    emit(currentState.copyWith(markers: updatedMarkers));

    // Recalculate proximity for new marker
    if (currentState.currentLocation != null) {
      add(MapLocationUpdated(currentState.currentLocation!));
    }
  }

  void _onRemoveMarker(MapRemoveMarker event, Emitter<MapState> emit) {
    if (state is! MapLoaded) return;

    final currentState = state as MapLoaded;
    final updatedMarkers = currentState.markers
        .where((marker) => marker.id != event.markerId)
        .toList();

    final updatedProximity = Map<String, ProximityZone>.from(
      currentState.markerProximity,
    )..remove(event.markerId);

    emit(
      currentState.copyWith(
        markers: updatedMarkers,
        markerProximity: updatedProximity,
      ),
    );
  }

  void _onClearAllMarkers(MapClearAllMarkers event, Emitter<MapState> emit) {
    if (state is! MapLoaded) return;

    final currentState = state as MapLoaded;
    emit(
      currentState.copyWith(
        markers: [],
        markerProximity: {},
        clearRoute: true,
        clearSelection: true,
      ),
    );
  }

  Future<void> _onGetDirections(
    MapGetDirections event,
    Emitter<MapState> emit,
  ) async {
    if (state is! MapLoaded) return;

    final currentState = state as MapLoaded;
    if (currentState.currentLocation == null) return;

    final marker = currentState.markers.firstWhere(
      (m) => m.id == event.markerId,
    );

    // Get route from current location to marker
    final route = await routingService.getRoute(
      currentState.currentLocation!,
      marker.position,
    );

    if (route != null) {
      emit(
        currentState.copyWith(
          activeRoute: route,
          selectedMarkerId: event.markerId,
        ),
      );
    }
  }

  void _onClearDirections(MapClearDirections event, Emitter<MapState> emit) {
    if (state is! MapLoaded) return;

    final currentState = state as MapLoaded;
    emit(currentState.copyWith(clearRoute: true, clearSelection: true));
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
