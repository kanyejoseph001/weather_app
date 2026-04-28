import 'package:dio/dio.dart';
import '../core/constants.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<WeatherModel> getCurrentWeather(String city) async {
    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {
          'q': city,
          'appid': AppConstants.apiKey,
          'units': 'metric',
        },
      );
      return WeatherModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<WeatherModel> getWeatherByCoords(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '/weather',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': AppConstants.apiKey,
          'units': 'metric',
        },
      );
      return WeatherModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ForecastModel> getForecast(String city) async {
    try {
      final response = await _dio.get(
        '/forecast',
        queryParameters: {
          'q': city,
          'appid': AppConstants.apiKey,
          'units': 'metric',
          'cnt': 40,
        },
      );
      return ForecastModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ForecastModel> getForecastByCoords(double lat, double lon) async {
    try {
      final response = await _dio.get(
        '/forecast',
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': AppConstants.apiKey,
          'units': 'metric',
          'cnt': 40,
        },
      );
      return ForecastModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timed out. Check your internet.';
    } else if (e.response?.statusCode == 404) {
      return 'City not found. Try another name.';
    } else if (e.response?.statusCode == 401) {
      return 'Invalid API key.';
    } else if (e.type == DioExceptionType.unknown) {
      return 'No internet connection.';
    }
    return 'Something went wrong. Please try again.';
  }
}
