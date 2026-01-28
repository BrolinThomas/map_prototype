# Quick Start Guide

## 🚀 Get Started in 3 Steps

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

### 3. Grant Permissions
When the app opens, allow location access.

---

## 🎯 What You'll See

1. **Map opens** showing your current location (blue pin)
2. **Tap the + button** to add a test marker nearby
3. **Walk around** and watch the circle color change:
   - 🟢 Green when far (>1000m)
   - 🟡 Yellow when approaching (500-1000m)
   - 🟠 Orange when near (200-500m)
   - 🔴 Red when very close (<200m)

---

## 📱 Testing Without Moving

### Option 1: Simulator Location
**Android Studio:**
1. Click the three dots (...) in the emulator toolbar
2. Go to Location
3. Set a custom location and move it around

**Xcode Simulator:**
1. Debug → Location → Custom Location
2. Enter different coordinates

### Option 2: Add Multiple Markers
1. Tap + button multiple times
2. Markers appear at different distances
3. See different colors immediately

---

## 🏗️ Architecture Overview

```
lib/
├── blocs/map/          # MapBloc handles location & proximity logic
├── services/           # LocationService for GPS tracking
├── models/             # MapMarker & ProximityZone data models
├── presentation/       # MapScreen UI
└── widgets/            # Reusable components
```

**Data Flow:**
```
GPS → LocationService → MapBloc → ProximityZone → UI Updates
```

---

## 🎨 Customization Examples

### Change Distance Thresholds
`lib/models/proximity_zone.dart`:
```dart
enum ProximityZone {
  farAway(2000, Color(0xFF4CAF50)),    // Was 1000
  approaching(1000, Color(0xFFFFEB3B)), // Was 500
  near(500, Color(0xFFFF9800)),         // Was 200
  veryClose(0, Color(0xFFF44336));
}
```

### Change Marker Radius
`lib/presentation/map_screen.dart` (line ~245):
```dart
radius: 2000, // Was 1000 (in meters)
```

### Change Update Frequency
`lib/services/location_service.dart`:
```dart
distanceFilter: 5, // Update every 5m instead of 10m
```

---

## ✅ Features Checklist

- ✅ Real-time location tracking
- ✅ No Google services (uses OpenStreetMap)
- ✅ Dynamic color-changing proximity zones
- ✅ Multiple markers support
- ✅ Smooth real-time updates
- ✅ Clean architecture (BLoC pattern)
- ✅ Android & iOS permissions configured

---

## 🐛 Troubleshooting

**Map not loading?**
- Check internet connection (needed for map tiles)

**Location not updating?**
- Ensure location permissions granted
- Check GPS is enabled
- Try restarting the app

**No color changes?**
- Make sure you've added markers (+ button)
- Move at least 10 meters
- Check location updates are working

---

## 📚 More Info

See `MAP_FEATURES.md` for detailed documentation.
See `ARCHITECTURE.md` for project structure details.

---

**Ready to test? Run `flutter run` and start moving! 🚗**
