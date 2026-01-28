# Testing Guide

## 🧪 How to Test the App

### Method 1: Real Device Testing (Recommended)

**Best for:** Seeing actual real-time updates

1. Connect your phone via USB
2. Enable Developer Options & USB Debugging
3. Run: `flutter run`
4. Walk around your neighborhood
5. Watch the colors change as you approach markers

**Tips:**
- Add a marker before you start walking
- Keep the app open while moving
- Move at least 10 meters to see updates

---

### Method 2: Android Emulator Location Simulation

**Best for:** Quick testing without moving

#### Setup:
1. Start Android emulator
2. Run: `flutter run`
3. Grant location permissions

#### Simulate Movement:
1. Click **three dots (...)** in emulator toolbar
2. Go to **Location** tab
3. Choose one of these options:

**Option A: Single Location**
- Enter coordinates manually
- Click "Send"
- Change coordinates and send again

**Option B: Route Playback**
- Click "Load GPX/KML"
- Select a route file
- Click "Play Route"

**Option C: Manual Map Movement**
- Use the map in the Location tab
- Click different points
- Watch your app update

#### Example Test Coordinates:
```
Start:  40.758896, -73.985130 (Times Square)
+200m:  40.760696, -73.985130 (Should be RED)
+500m:  40.762496, -73.985130 (Should be ORANGE)
+800m:  40.765196, -73.985130 (Should be YELLOW)
+1200m: 40.769696, -73.985130 (Should be GREEN)
```

---

### Method 3: iOS Simulator Location Simulation

**Best for:** Testing on Mac

#### Setup:
1. Start iOS simulator
2. Run: `flutter run`
3. Grant location permissions

#### Simulate Movement:
1. In simulator menu: **Features → Location**
2. Choose:
   - **Custom Location** - Enter lat/lng manually
   - **City Run** - Simulates movement
   - **Freeway Drive** - Simulates driving

#### Or use Xcode:
1. Open Xcode
2. **Debug → Simulate Location**
3. Choose from preset locations
4. Or add custom GPX file

---

### Method 4: Quick In-App Testing

**Best for:** Instant visual feedback

1. Run the app
2. Tap the **+** button multiple times
3. This adds markers at different distances
4. You'll see different colors immediately:
   - First marker: ~550m away (YELLOW/ORANGE)
   - Each tap adds another marker

**Why this works:**
- Markers are placed at fixed distances
- You can see all color zones at once
- No movement required

---

## 🎯 What to Test

### ✅ Basic Functionality
- [ ] App opens and requests location permission
- [ ] Map loads with your location (blue pin)
- [ ] Can zoom in/out
- [ ] Can pan around the map
- [ ] Center button works

### ✅ Marker Features
- [ ] Can add markers with + button
- [ ] Markers appear on map (red pins)
- [ ] Circles appear around markers
- [ ] Multiple markers work

### ✅ Proximity Colors
- [ ] Green circle when far (>1000m)
- [ ] Yellow circle when approaching (500-1000m)
- [ ] Orange circle when near (200-500m)
- [ ] Red circle when very close (<200m)

### ✅ Real-time Updates
- [ ] Location updates as you move
- [ ] Colors change automatically
- [ ] No lag or freezing
- [ ] Smooth transitions

### ✅ Legend
- [ ] Legend shows all 4 colors
- [ ] Legend is readable
- [ ] Legend stays on top

---

## 🐛 Common Issues & Solutions

### Issue: "Location permission denied"
**Solution:** 
- Go to device Settings → Apps → map_prototype → Permissions
- Enable Location permission
- Restart the app

### Issue: "Map tiles not loading"
**Solution:**
- Check internet connection
- Try switching between WiFi/Mobile data
- Restart the app

### Issue: "Location not updating"
**Solution:**
- Ensure GPS is enabled
- Go outside (GPS works better outdoors)
- Wait 30 seconds for GPS lock
- Check location permission is "While using app"

### Issue: "Colors not changing"
**Solution:**
- Make sure you've added markers (+ button)
- Move at least 10 meters
- Check that location is updating (blue pin moves)

### Issue: "App crashes on startup"
**Solution:**
- Run: `flutter clean`
- Run: `flutter pub get`
- Run: `flutter run`

---

## 📊 Expected Behavior

### Scenario 1: Standing Still
- Blue pin at your location
- Circles around markers
- Colors based on current distance
- No changes (you're not moving)

### Scenario 2: Walking Toward Marker
- Blue pin moves with you
- Distance decreases
- Color changes: Green → Yellow → Orange → Red
- Smooth, automatic updates

### Scenario 3: Walking Away from Marker
- Blue pin moves with you
- Distance increases
- Color changes: Red → Orange → Yellow → Green
- Smooth, automatic updates

### Scenario 4: Multiple Markers
- Each marker has its own circle
- Each circle has independent color
- Colors based on distance to each marker
- All update simultaneously

---

## 🎬 Test Scenarios

### Test 1: Basic Flow (2 minutes)
1. Open app
2. Grant permissions
3. Wait for location lock
4. Add one marker
5. Note the color
6. Walk 50 meters
7. Check if color changed

### Test 2: All Colors (5 minutes)
1. Open app
2. Add marker
3. Walk to >1000m away (GREEN)
4. Walk to 700m away (YELLOW)
5. Walk to 300m away (ORANGE)
6. Walk to 100m away (RED)

### Test 3: Multiple Markers (3 minutes)
1. Open app
2. Add 3-4 markers
3. Walk around
4. Verify each circle changes independently

### Test 4: Stress Test (10 minutes)
1. Add 10+ markers
2. Walk around for 10 minutes
3. Check for lag or crashes
4. Verify all colors update correctly

---

## 📱 Device Requirements

### Minimum:
- Android 6.0+ or iOS 12.0+
- GPS capability
- Internet connection (for map tiles)

### Recommended:
- Android 10+ or iOS 14+
- Good GPS signal (outdoors)
- WiFi or 4G connection

---

## 🚀 Quick Test Commands

```bash
# Clean build
flutter clean && flutter pub get && flutter run

# Run with verbose logging
flutter run -v

# Run on specific device
flutter devices
flutter run -d <device-id>

# Build release APK for testing
flutter build apk --release
```

---

## ✅ Test Checklist

Print this and check off as you test:

```
□ App installs successfully
□ Location permission requested
□ Map loads with tiles
□ Blue pin shows my location
□ Can add markers
□ Markers appear on map
□ Circles appear around markers
□ Green color at >1000m
□ Yellow color at 500-1000m
□ Orange color at 200-500m
□ Red color at <200m
□ Colors change when moving
□ Updates are smooth
□ No crashes or freezes
□ Legend is visible
□ Center button works
□ Can zoom and pan
□ Multiple markers work
□ Each marker updates independently
```

---

**Happy Testing! 🎉**

If you find any issues, check the troubleshooting section or review the implementation files.
