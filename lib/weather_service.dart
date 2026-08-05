import 'dart:convert';

import 'package:http/http.dart' as http;

import 'weather_model.dart';

class WeatherService {
  static const String _url =
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=8.9806'
      '&longitude=38.7578'
      '&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,wind_direction_10m';

  Future<Weather> getWeather() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return Weather.fromJson(data);
    } else {
      throw Exception(
        'Failed to load weather data: ${response.statusCode}',
      );
    }
  }
}