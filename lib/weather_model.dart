class Weather {
  final double temperature;
  final int humidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;
  final double windDirection;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
    required this.windDirection,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'];

    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      apparentTemperature:
          (current['apparent_temperature'] as num).toDouble(),
      precipitation: (current['precipitation'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      windDirection: (current['wind_direction_10m'] as num).toDouble(),
    );
  }
}