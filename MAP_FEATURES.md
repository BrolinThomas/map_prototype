# Live Location Map Tracker

## Features Implemented ✅

### Core Functionality
- **Real-time Location Tracking**: Your location updates automatically as you move
- **OpenStreetMap Integration**: No Google services required
- **Dynamic Proximity Zones**: Circle colors change based on distance
- **Multiple Markers**: Add unlimited location markers

### Proximity Color System
The app changes circle colors dynamically based on your distance from markers:

- 🟢 **Green** - Far away (> 1000m)
- 🟡 **Yellow** - Approaching (500-1000m)  
- 🟠 **Orange** - Near (200-500m)
- 🔴 **Red** - Very close (< 200m)

### UI Features
- **Live location indicator** (blue pin)
- **Custom markers** (red pins)
- **Visual legend** showing proximity zones
- **Center on location** button
- **Add marker** button (adds marker ~500m north for testing)

## How to Use

### First Launch
1. Open the app
2. Grant location permissions when prompted
3. Map will center on your current location

### While Traveling
- Your blue location marker updates automatically
- Circle colors change in real-time as you move
- No manual refresh needed

### Adding Markers
1. Tap the **+** (add location) button
2. A marker appears near your location for testing
3. Watch the circle color change as you move

### Navigation
- Tap the **target** button to re-center on your location
- Pinch to zoom in/out
- Drag to pan around the map

## Technical Details

### Architecture
Follows the project's clean architecture:
- **BLoC**: `MapBloc` handles all state and location updates
- **Service**: `LocationService` manages GPS and distance calculations
- **Models**: `MapMarker` and `ProximityZone` for data
- **UI**: `MapScreen` displays the map and markers

### Location Updates
- Updates every 10 meters of movement
- High accuracy GPS
- Automatic permission handling

### Distance Calculation
Uses the Haversine formula for accurate distance calculation between coordinates.

## Testing Tips

Since you need to move to see color changes:

1. **Simulator Testing**: Use location simulation in your IDE
2. **Real Device**: Walk/drive around with the app open
3. **Quick Test**: The "Add Marker" button places a marker nearby so you can test by walking a short distance

## Permissions Required

### Android
- `ACCESS_FINE_LOCATION`
- `ACCESS_COARSE_LOCATION`
- `INTERNET` (for map tiles)

### iOS
- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription`

All permissions are already configured in the manifest files.

## Running the App

```bash
# Install dependencies
flutter pub get

# Run on device/emulator
flutter run

# For iOS (from project root)
cd ios && pod install && cd ..
flutter run
```

## Customization

### Change Proximity Thresholds
Edit `lib/models/proximity_zone.dart`:
```dart
enum ProximityZone {
  farAway(1000, Color(0xFF4CAF50)),    // Change 1000 to your value
  approaching(500, Color(0xFFFFEB3B)),  // Change 500 to your value
  near(200, Color(0xFFFF9800)),         // Change 200 to your value
  veryClose(0, Color(0xFFF44336));
}
```

### Change Marker Radius
When adding markers in `map_screen.dart`:
```dart
final marker = MapMarker(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  position: newMarkerPosition,
  radius: 1000, // Change this value (in meters)
  label: 'Marker ${state.markers.length + 1}',
);
```

### Change Location Update Frequency
Edit `lib/services/location_service.dart`:
```dart
const locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 10, // Update every X meters
);
```

## Troubleshooting

### Location Not Updating
- Check location permissions are granted
- Ensure GPS is enabled on device
- Try restarting the app

### Map Not Loading
- Check internet connection (needed for tiles)
- Verify `INTERNET` permission is granted

### Colors Not Changing
- Ensure you're moving (10m minimum)
- Check that markers are added
- Verify location updates in console logs

## Future Enhancements

Possible additions:
- Persistent markers (save to local storage)
- Custom marker labels and icons
- Geofencing notifications
- Route tracking
- Multiple proximity zones per marker
- Marker editing/deletion UI
