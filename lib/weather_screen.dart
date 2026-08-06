import 'package:flutter/material.dart';
import 'weather_model.dart';
import 'weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();

  Weather? weather;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    try {
      final result = await _weatherService.getWeather();

      setState(() {
        weather = result;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load weather';
        isLoading = false;
      });
    }
  }

  String getWeatherDescription(int code) {
    if (code == 0) {
      return 'Clear sky';
    } else if (code <= 3) {
      return 'Partly cloudy';
    } else if (code <= 48) {
      return 'Foggy';
    } else if (code <= 57) {
      return 'Drizzle';
    } else if (code <= 67) {
      return 'Rain';
    } else if (code <= 77) {
      return 'Snow';
    } else if (code <= 82) {
      return 'Rain showers';
    } else if (code <= 86) {
      return 'Snow showers';
    } else {
      return 'Thunderstorm';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            size: 28,
            color: Colors.white,
          ),
          onPressed: () {},
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.calendar_today_outlined,
              size: 24,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.3),
            radius: 0.9,
            colors: [
              Color(0xFF5A3D2B),
              Color(0xFF20202A),
              Color(0xFF131318),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),

                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      // Location
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Addis Ababa, ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            TextSpan(
                              text: 'Ethiopia',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white70,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Weather image
                      Image.asset(
                        'assets/images/img.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 10),

                      // Temperature
                      if (isLoading)
                        const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      else if (errorMessage != null)
                        const Text(
                          '--°C',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              weather!.temperature.round().toString(),
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),

                            const Text(
                              '°',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.only(
                                top: 25.0,
                                left: 4.0,
                              ),
                              child: Text(
                                'C',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 5),

                      // Weather description
                      Text(
                        isLoading
                            ? 'Loading weather...'
                            : errorMessage != null
                                ? errorMessage!
                                : getWeatherDescription(
                                    weather!.weatherCode,
                                  ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Weather details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildWeatherDetail(
                            Icons.air,
                            weather == null
                                ? '--'
                                : '${weather!.windSpeed.round()}km/hr',
                          ),

                          _buildWeatherDetail(
                            Icons.water_drop_outlined,
                            weather == null
                                ? '--'
                                : '${weather!.humidity}%',
                          ),

                         
                          _buildWeatherDetail(
                            Icons.light_mode_outlined,
                            '8hr',
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Hourly Forecast title
                      Row(
                        children: const [
                          Icon(
                            Icons.access_time,
                            size: 20,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Hourly Forecast',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Hourly forecast
                      SizedBox(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildHourlyCard(
                              'Now',
                              weather == null
                                  ? '--°'
                                  : '${weather!.temperature.round()}°',
                              true,
                            ),
                            _buildHourlyCard('Now', '29°', true),
      _buildHourlyCard('5pm', '28°', false),
      _buildHourlyCard('6pm', '28°', false),
      _buildHourlyCard('7pm', '27°', false),
      _buildHourlyCard('8pm', '26°', false),
      _buildHourlyCard('9pm', '25°', false),
      _buildHourlyCard('10pm', '24°', false),
      _buildHourlyCard('11pm', '24°', false),
      _buildHourlyCard('12am', '23°', false),
      _buildHourlyCard('1am', '23°', false),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Bottom navigation
              Container(
                height: 70,
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFF262634).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(40),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Icon(
                      Icons.home_filled,
                      size: 28,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.search,
                      size: 28,
                      color: Colors.white54,
                    ),
                    Icon(
                      Icons.notifications_none,
                      size: 28,
                      color: Colors.white54,
                    ),
                    Icon(
                      Icons.map_outlined,
                      size: 28,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(
    IconData icon,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 22,
          color: Colors.white70,
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyCard(
    String time,
    String temp,
    bool isNow,
  ) {
    return Container(
      width: 75,
      margin: const EdgeInsets.only(right: 12),

      decoration: BoxDecoration(
        color: const Color(0xFF232334),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          const Icon(
            Icons.cloud,
            color: Colors.white,
            size: 30,
          ),

          const SizedBox(height: 12),

          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isNow
                  ? FontWeight.bold
                  : FontWeight.w400,
              color: isNow
                  ? Colors.white
                  : Colors.white70,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            temp,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
