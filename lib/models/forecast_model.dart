class ForecastItem {
  final DateTime dateTime;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final double pop; // probability of precipitation

  ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.pop,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      condition: json['weather'][0]['main'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pop: (json['pop'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}

class ForecastModel {
  final String cityName;
  final String country;
  final List<ForecastItem> items;

  ForecastModel({
    required this.cityName,
    required this.country,
    required this.items,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      cityName: json['city']['name'] ?? '',
      country: json['city']['country'] ?? '',
      items: (json['list'] as List)
          .map((item) => ForecastItem.fromJson(item))
          .toList(),
    );
  }

  // Group by day
  Map<String, List<ForecastItem>> get byDay {
    final Map<String, List<ForecastItem>> grouped = {};
    for (final item in items) {
      final key =
          '${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}';
      grouped.putIfAbsent(key, () => []).add(item);
    }
    return grouped;
  }

  // Today's hourly
  List<ForecastItem> get todayHourly {
    final today = DateTime.now();
    return items
        .where(
          (item) =>
              item.dateTime.day == today.day &&
              item.dateTime.month == today.month,
        )
        .toList();
  }

  // Daily summary (one item per day)
  List<ForecastItem> get dailySummary {
    final Map<String, ForecastItem> daily = {};
    for (final item in items) {
      final key =
          '${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}';
      if (!daily.containsKey(key)) {
        daily[key] = item;
      }
    }
    return daily.values.take(5).toList();
  }
}
