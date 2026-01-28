import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../blocs/map/map_bloc.dart';
import '../blocs/map/map_event.dart';
import '../blocs/map/map_state.dart';
import '../models/map_marker.dart';
import '../models/proximity_zone.dart';
import '../services/location_service.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapBloc(LocationService())..add(MapInitialize()),
      child: const MapView(),
    );
  }
}

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MapPermissionDenied) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Location permission denied'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MapBloc>().add(MapInitialize());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is MapError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is MapLoaded) {
            return Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: state.currentLocation ?? const LatLng(0, 0),
                    initialZoom: 15.0,
                    minZoom: 5.0,
                    maxZoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.map_prototype',
                    ),
                    // Draw circles for markers
                    CircleLayer(
                      circles: state.markers.map((marker) {
                        final zone =
                            state.markerProximity[marker.id] ??
                            ProximityZone.farAway;
                        return CircleMarker(
                          point: marker.position,
                          radius: marker.radius,
                          useRadiusInMeter: true,
                          color: zone.color.withValues(alpha: 0.3),
                          borderColor: zone.color,
                          borderStrokeWidth: 2,
                        );
                      }).toList(),
                    ),
                    // Draw marker pins
                    MarkerLayer(
                      markers: [
                        // User location marker
                        if (state.currentLocation != null)
                          Marker(
                            point: state.currentLocation!,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                        // Custom markers
                        ...state.markers.map((marker) {
                          return Marker(
                            point: marker.position,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
                // Legend
                Positioned(top: 16, right: 16, child: _buildLegend(state)),
                // Add marker button
                Positioned(
                  bottom: 80,
                  right: 16,
                  child: FloatingActionButton(
                    heroTag: 'add_marker',
                    onPressed: () =>
                        _addMarkerAtCurrentLocation(context, state),
                    child: const Icon(Icons.add_location),
                  ),
                ),
                // Center on user button
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    heroTag: 'center',
                    onPressed: () {
                      if (state.currentLocation != null) {
                        _mapController.move(state.currentLocation!, 15.0);
                      }
                    },
                    child: const Icon(Icons.my_location),
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  Widget _buildLegend(MapLoaded state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Proximity',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          _legendItem(ProximityZone.farAway.color, '> 1000m'),
          _legendItem(ProximityZone.approaching.color, '500-1000m'),
          _legendItem(ProximityZone.near.color, '200-500m'),
          _legendItem(ProximityZone.veryClose.color, '< 200m'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.3),
              border: Border.all(color: color, width: 2),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _addMarkerAtCurrentLocation(BuildContext context, MapLoaded state) {
    if (state.currentLocation == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Waiting for location...')));
      return;
    }

    // Add marker 500m north of current location for demo
    final newMarkerPosition = LatLng(
      state.currentLocation!.latitude + 0.005,
      state.currentLocation!.longitude,
    );

    final marker = MapMarker(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      position: newMarkerPosition,
      radius: 1000, // 1km radius
      label: 'Marker ${state.markers.length + 1}',
    );

    context.read<MapBloc>().add(MapAddMarker(marker));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Marker added!')));
  }
}
