import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class CacheService {
  static const String weatherBox = 'weather_cache';
  static const String forecastBox = 'forecast_cache';
  static const String lastCityKey = 'last_city';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(weatherBox);
    await Hive.openBox(forecastBox);
    await Hive.openBox('settings');
  }

  Future<void> cacheWeather(String city, WeatherModel weather) async {
    final box = Hive.box(weatherBox);
    await box.put(city.toLowerCase(), {
      'data': jsonEncode(weather.toJson()),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<WeatherModel?> getCachedWeather(String city) async {
    final box = Hive.box(weatherBox);
    final cached = box.get(city.toLowerCase());
    if (cached == null) return null;

    final timestamp = cached['timestamp'] as int;
    final age = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (age > 30 * 60 * 1000) return null; // 30 min cache

    final data = jsonDecode(cached['data'] as String);
    return WeatherModel.fromJson(_reconstructJson(data));
  }

  Future<void> saveLastCity(String city) async {
    final box = Hive.box('settings');
    await box.put(lastCityKey, city);
  }

  String? getLastCity() {
    final box = Hive.box('settings');
    return box.get(lastCityKey) as String?;
  }

  Map<String, dynamic> _reconstructJson(Map data) {
    return {
      'name': data['cityName'],
      'sys': {
        'country': data['country'],
        'sunrise': data['sunrise'] ~/ 1000,
        'sunset': data['sunset'] ~/ 1000,
      },
      'main': {
        'temp': data['temperature'],
        'feels_like': data['feelsLike'],
        'temp_min': data['tempMin'],
        'temp_max': data['tempMax'],
        'humidity': data['humidity'],
        'pressure': data['pressure'],
      },
      'wind': {'speed': data['windSpeed']},
      'weather': [
        {
          'main': data['condition'],
          'description': data['description'],
          'icon': data['icon'],
        },
      ],
      'visibility': data['visibility'],
      'dt': data['dateTime'] ~/ 1000,
    };
  }
}

