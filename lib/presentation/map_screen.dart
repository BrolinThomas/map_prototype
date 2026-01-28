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
import '../services/routing_service.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MapBloc(LocationService(), RoutingService())..add(MapInitialize()),
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
                    // Draw route if active
                    if (state.activeRoute != null)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: state.activeRoute!.routePoints,
                            strokeWidth: 5.0,
                            color: Colors.blue,
                            borderStrokeWidth: 2.0,
                            borderColor: Colors.white,
                          ),
                        ],
                      ),
                    // Draw marker pins
                    MarkerLayer(
                      markers: [
                        // User location marker with directional arrow
                        if (state.currentLocation != null)
                          Marker(
                            point: state.currentLocation!,
                            width: 50,
                            height: 50,
                            child: _buildUserLocationMarker(state),
                          ),
                        // Custom markers
                        ...state.markers.map((marker) {
                          final isSelected =
                              state.selectedMarkerId == marker.id;
                          return Marker(
                            point: marker.position,
                            width: 40,
                            height: 40,
                            child: GestureDetector(
                              onTap: () => _onMarkerTapped(context, marker.id),
                              child: Icon(
                                Icons.location_pin,
                                color: isSelected ? Colors.green : Colors.red,
                                size: isSelected ? 50 : 40,
                              ),
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
                // Route info panel
                if (state.activeRoute != null)
                  Positioned(
                    bottom: 90,
                    left: 16,
                    right: 16,
                    child: _buildRouteInfoPanel(context, state),
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

  void _onMarkerTapped(BuildContext context, String markerId) {
    final bloc = context.read<MapBloc>();
    final state = bloc.state;

    if (state is MapLoaded) {
      if (state.selectedMarkerId == markerId) {
        // Deselect if already selected
        bloc.add(MapClearDirections());
      } else {
        // Show bottom sheet with options
        _showMarkerOptions(context, markerId);
      }
    }
  }

  void _showMarkerOptions(BuildContext context, String markerId) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.directions, color: Colors.blue),
              title: const Text('Get Directions'),
              onTap: () {
                Navigator.pop(sheetContext);
                _getDirectionsToMarker(context, markerId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Remove Marker'),
              onTap: () {
                Navigator.pop(sheetContext);
                context.read<MapBloc>().add(MapRemoveMarker(markerId));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteInfoPanel(BuildContext context, MapLoaded state) {
    final route = state.activeRoute!;
    final currentSpeed = state.currentSpeed ?? 0.0;

    // Use real-time speed for ETA if available
    final duration = currentSpeed > 0.5
        ? route.getUpdatedDuration(currentSpeed)
        : route.formattedDuration;

    final eta = currentSpeed > 0.5
        ? route.getUpdatedETA(currentSpeed)
        : route.estimatedArrival;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Navigation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  context.read<MapBloc>().add(MapClearDirections());
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _routeInfoItem(
                  Icons.straighten,
                  'Distance',
                  route.formattedDistance,
                ),
              ),
              Expanded(
                child: _routeInfoItem(Icons.access_time, 'Duration', duration),
              ),
              Expanded(child: _routeInfoItem(Icons.schedule, 'ETA', eta)),
            ],
          ),
          if (currentSpeed > 0.5)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.speed, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${(currentSpeed * 3.6).toStringAsFixed(0)} km/h',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Follow the blue route on the map'),
                  ),
                );
              },
              icon: const Icon(Icons.navigation),
              label: const Text('Following Route'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _routeInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildUserLocationMarker(MapLoaded state) {
    // If we have heading and are in navigation mode, show directional arrow
    if (state.activeRoute != null && state.currentHeading != null) {
      return Transform.rotate(
        angle:
            state.currentHeading! *
            (3.14159 / 180), // Convert degrees to radians
        child: const Icon(
          Icons.navigation,
          color: Colors.blue,
          size: 40,
          shadows: [Shadow(color: Colors.white, blurRadius: 4)],
        ),
      );
    }

    // Otherwise show regular location pin
    return const Icon(Icons.my_location, color: Colors.blue, size: 40);
  }

  void _getDirectionsToMarker(BuildContext context, String markerId) async {
    final bloc = context.read<MapBloc>();
    final state = bloc.state;

    if (state is! MapLoaded || state.currentLocation == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calculating route...'),
        duration: Duration(seconds: 2),
      ),
    );

    // Get directions
    bloc.add(MapGetDirections(markerId));

    // Wait a bit for route to be calculated
    await Future.delayed(const Duration(milliseconds: 500));

    // Zoom to show full route
    final updatedState = bloc.state;
    if (updatedState is MapLoaded && updatedState.activeRoute != null) {
      _zoomToRoute(updatedState);
    }
  }

  void _zoomToRoute(MapLoaded state) {
    if (state.activeRoute == null || state.currentLocation == null) return;

    final route = state.activeRoute!;
    final allPoints = [state.currentLocation!, ...route.routePoints];

    // Calculate bounds
    double minLat = allPoints.first.latitude;
    double maxLat = allPoints.first.latitude;
    double minLng = allPoints.first.longitude;
    double maxLng = allPoints.first.longitude;

    for (final point in allPoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    // Add padding
    final latPadding = (maxLat - minLat) * 0.2;
    final lngPadding = (maxLng - minLng) * 0.2;

    final bounds = LatLngBounds(
      LatLng(minLat - latPadding, minLng - lngPadding),
      LatLng(maxLat + latPadding, maxLng + lngPadding),
    );

    // Fit bounds to map
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
    );
  }
}
