# 🌤️ SkyWatch — Flutter Weather App

A beautifully designed, feature-rich weather forecast app built with Flutter for the HNG Internship Stage 3 task. SkyWatch delivers real-time weather data with smooth animations and an elegant dark UI.

---




## ✨ Features

### 🌡️ Current Weather Display
- Real-time temperature, feels like, min/max
- Weather condition (Sunny, Rainy, Cloudy, Stormy, Snowy)
- Humidity, wind speed, visibility, pressure
- Sunrise and sunset times
- Dynamic background color based on weather condition

### 📍 Location-Based Weather
- Automatically fetches weather for your current GPS location
- Request location permission with graceful fallback
- Manual city search as alternative

### 🔍 City Search
- Search weather for any city worldwide
- Popular cities quick-select chips
- Instant results on submit

### 📅 Forecast View
- **Hourly forecast** — next 8 hours with icons and temperatures
- **5-day forecast** — daily high/low with precipitation probability
- Weather icons for each forecast item

### 📶 Offline Caching
- Weather data cached locally using Hive
- 30-minute cache validity
- Offline banner indicator when viewing cached data
- Graceful error when no cache available

### ⚠️ Error Handling
- No internet connection detection
- Location permission denied handling
- API failures with user-friendly messages
- City not found error
- Retry button on all error states

### ⏳ Loading States
- Shimmer skeleton loader while fetching data
- Smooth transition from loading to content
- Pull-to-refresh support

---

## 🎬 Animations

SkyWatch implements animations in **four key areas:**

### 1. Screen Transitions
- **Splash → Home:** Fade transition (600ms)
- **Home → Search:** Slide-in from right (300ms)

### 2. Weather Card
- Scale + opacity animation on weather data load (700ms)
- Re-animates when switching cities
- Elastic ease-out curve for a satisfying feel

### 3. List/Grid Item Entrance
- **Hourly forecast items:** Staggered slide-up entrance (80ms delay per item)
- **5-day forecast rows:** Staggered slide-in from right (100ms delay per row)
- Each item has its own `TweenAnimationBuilder` for independent control

### 4. UI Components
- **Splash screen:** Logo scale with elastic bounce + text slide-up
- **Error screen:** Bounce scale animation on appearance
- **Background:** Animated color transition based on weather condition
- **Search screen:** Slide-up entrance animation

---

## 🌐 API Used

### OpenWeatherMap API
- **Website:** https://openweathermap.org
- **Endpoints used:**
  - `GET /weather` — Current weather by city name or coordinates
  - `GET /forecast` — 5-day / 3-hour forecast data
- **Free tier:** 60 calls/minute, 1,000,000 calls/month
- **Units:** Metric (°C)

---

## 🏗️ Architecture

This app follows a **feature-first clean architecture** pattern:

```
lib/
├── main.dart
├── core/
│   ├── constants.dart        # API keys, base URLs
│   └── theme.dart            # Colors, dark theme
├── models/
│   ├── weather_model.dart    # Current weather data model
│   └── forecast_model.dart   # Forecast data model
├── services/
│   ├── weather_service.dart  # API calls via Dio
│   ├── location_service.dart # GPS location via Geolocator
│   └── cache_service.dart    # Hive local caching
├── providers/
│   └── weather_provider.dart # Riverpod state management
├── screens/
│   ├── splash_screen.dart    # Animated splash
│   ├── home_screen.dart      # Main weather screen
│   └── search_screen.dart    # City search
└── widgets/
    ├── weather_card.dart      # Main weather display
    ├── hourly_forecast.dart   # Hourly scroll list
    ├── daily_forecast.dart    # 5-day forecast list
    ├── weather_details.dart   # Details grid
    ├── shimmer_loading.dart   # Skeleton loader
    └── error_widget.dart      # Error + retry UI
```

**State Management:** Riverpod (`StateNotifierProvider`)  
**Data Flow:** UI → Provider → Service → API → Model → UI

---

## 📦 Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_riverpod` | ^2.5.1 | State management |
| `dio` | ^5.4.0 | HTTP requests |
| `hive` | ^2.2.3 | Local storage |
| `hive_flutter` | ^1.1.0 | Hive Flutter integration |
| `geolocator` | ^11.0.0 | GPS location |
| `shimmer` | ^3.0.0 | Skeleton loading |
| `cached_network_image` | ^3.3.1 | Image caching |
| `google_fonts` | ^6.2.1 | Inter font |
| `intl` | ^0.19.0 | Date/time formatting |
| `connectivity_plus` | ^6.0.3 | Network detection |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- OpenWeatherMap API key (free at https://openweathermap.org)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/kanyejoseph001/weather_app
cd weather-app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Add your API key**

Open `lib/core/constants.dart` and replace the API key:
```dart
static const String apiKey = '56c134747f976bfb160f416a43e59920';
```

4. **Run the app**
```bash
flutter run
```

5. **Build APK**
```bash
flutter build apk --release
```

---

## 📲 Live Preview

> Try the app on Appetize.io: **(https://appetize.io/app/b_an6a3n37r3ah4ovo7h5scvruaa)**

---

## 🔑 Android Permissions

The following permissions are required in `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

---

## 🎓 Built For

**HNG Internship — Mobile Track Stage 3**  
Task: Build a Weather or News app with API integration, offline caching, animations, and proper error handling.

---

## 👤 Author

**Adekanye Joseph**  
- GitHub: kanyejoseph001(https://github.com/kanyejoseph001)
- LinkedIn: www.linkedin.com/in/adekanye-joseph-98a385281


---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
