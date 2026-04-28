class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final String condition;
  final String description;
  final String icon;
  final int visibility;
  final int pressure;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime dateTime;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.description,
    required this.icon,
    required this.visibility,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
    required this.dateTime,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      country: json['sys']['country'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      condition: json['weather'][0]['main'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      visibility: (json['visibility'] as num?)?.toInt() ?? 0,
      pressure: json['main']['pressure'] as int,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        (json['sys']['sunrise'] as int) * 1000,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        (json['sys']['sunset'] as int) * 1000,
      ),
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': cityName,
    'country': country,
    'temperature': temperature,
    'feelsLike': feelsLike,
    'tempMin': tempMin,
    'tempMax': tempMax,
    'humidity': humidity,
    'windSpeed': windSpeed,
    'condition': condition,
    'description': description,
    'icon': icon,
    'visibility': visibility,
    'pressure': pressure,
    'sunrise': sunrise.millisecondsSinceEpoch,
    'sunset': sunset.millisecondsSinceEpoch,
    'dateTime': dateTime.millisecondsSinceEpoch,
  };

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';

  bool get isDay {
    final now = DateTime.now();
    return now.isAfter(sunrise) && now.isBefore(sunset);
  }
}
