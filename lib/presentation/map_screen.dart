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
        title: const Text('Proximity Map'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                    onTap: (tapPosition, point) =>
                        _addMarkerAtPosition(context, point),
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
                // Instruction banner
                // Positioned(
                //   top: 16,
                //   left: 16,
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 12,
                //       vertical: 8,
                //     ),
                //     decoration: BoxDecoration(
                //       color: Colors.blue,
                //       borderRadius: BorderRadius.circular(8),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black.withValues(alpha: 0.2),
                //           blurRadius: 4,
                //         ),
                //       ],
                //     ),
                //     child: const Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Icon(Icons.touch_app, color: Colors.white, size: 20),
                //         SizedBox(width: 8),
                //         Text(
                //           'Tap map to add marker',
                //           style: TextStyle(color: Colors.white, fontSize: 14),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Clear all markers button (only show if there are markers)
                if (state.markers.isNotEmpty)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: FloatingActionButton.extended(
                      heroTag: 'clear',
                      onPressed: () => _showClearConfirmation(context),
                      backgroundColor: Colors.white,
                      icon: const Icon(Icons.delete_forever_outlined),
                      label: const Text('Clear All'),
                    ),
                  ),
                // Center on user button
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
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

  void _addMarkerAtPosition(BuildContext context, LatLng position) {
    final marker = MapMarker(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      position: position,
      radius: 1000, // 1km radius
      label: 'Marker',
    );

    context.read<MapBloc>().add(MapAddMarker(marker));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Marker added!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear All Markers'),
        content: const Text('Are you sure you want to remove all markers?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<MapBloc>().add(MapClearAllMarkers());
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All markers cleared!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
