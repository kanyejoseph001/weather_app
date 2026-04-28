import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/cache_service.dart';

final weatherServiceProvider = Provider((ref) => WeatherService());
final locationServiceProvider = Provider((ref) => LocationService());
final cacheServiceProvider = Provider((ref) => CacheService());

// Current city
final currentCityProvider = StateProvider<String>((ref) => 'Lagos');

// Weather state
class WeatherState {
  final WeatherModel? weather;
  final ForecastModel? forecast;
  final bool isLoading;
  final String? error;
  final bool isOffline;

  const WeatherState({
    this.weather,
    this.forecast,
    this.isLoading = false,
    this.error,
    this.isOffline = false,
  });

  WeatherState copyWith({
    WeatherModel? weather,
    ForecastModel? forecast,
    bool? isLoading,
    String? error,
    bool? isOffline,
  }) => WeatherState(
    weather: weather ?? this.weather,
    forecast: forecast ?? this.forecast,
    isLoading: isLoading ?? this.isLoading,
    error: error,
    isOffline: isOffline ?? this.isOffline,
  );
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final CacheService _cacheService;
  final Ref _ref;

  WeatherNotifier(
    this._weatherService,
    this._locationService,
    this._cacheService,
    this._ref,
  ) : super(const WeatherState());

  Future<void> loadWeather(String city) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOnline = connectivityResult != ConnectivityResult.none;

      if (!isOnline) {
        final cached = await _cacheService.getCachedWeather(city);
        if (cached != null) {
          state = state.copyWith(
            weather: cached,
            isLoading: false,
            isOffline: true,
          );
          return;
        }
        state = state.copyWith(
          isLoading: false,
          error: 'No internet connection and no cached data available.',
          isOffline: true,
        );
        return;
      }

      final weather = await _weatherService.getCurrentWeather(city);
      final forecast = await _weatherService.getForecast(city);

      await _cacheService.cacheWeather(city, weather);
      await _cacheService.saveLastCity(city);
      _ref.read(currentCityProvider.notifier).state = city;

      state = state.copyWith(
        weather: weather,
        forecast: forecast,
        isLoading: false,
        isOffline: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadByLocation() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final position = await _locationService.getCurrentLocation();
      if (position == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Location permission denied. Please enable location access.',
        );
        return;
      }

      final weather = await _weatherService.getWeatherByCoords(
        position.latitude,
        position.longitude,
      );
      final forecast = await _weatherService.getForecastByCoords(
        position.latitude,
        position.longitude,
      );

      await _cacheService.cacheWeather(weather.cityName, weather);
      await _cacheService.saveLastCity(weather.cityName);
      _ref.read(currentCityProvider.notifier).state = weather.cityName;

      state = state.copyWith(
        weather: weather,
        forecast: forecast,
        isLoading: false,
        isOffline: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void retry() {
    final city = _ref.read(currentCityProvider);
    loadWeather(city);
  }
}

final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>((
  ref,
) {
  return WeatherNotifier(
    ref.read(weatherServiceProvider),
    ref.read(locationServiceProvider),
    ref.read(cacheServiceProvider),
    ref,
  );
});
