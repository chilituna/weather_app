import 'package:flutter/material.dart';
import '../models/current_weather.dart';
import '../models/location.dart';
import '../utils/weather_utils.dart';

class Currently extends StatelessWidget {
  final LocationData? locationData;
  final CurrentWeather? currentWeather;


  const Currently({super.key, required this.currentWeather, required this.locationData});


  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Current Weather',
              style: TextStyle(fontSize: 24),
            ),
            if (locationData != null) ...[
              const SizedBox(height: 8),
              Text(locationData!.city),
              Text('${locationData!.region}, ${locationData!.country}'),
            ],

        const SizedBox(height: 16),
            if (currentWeather != null) ...[
              SizedBox(height: 16),
              Text(
                '${currentWeather!.temperature}°C',
              ),
              Text(
                getWeatherDescription(currentWeather!.weatherCode),
              ),
              Text(
                'Wind Speed: ${currentWeather!.windSpeed} km/h',
              ),
            ],
          ],
        );
  }
}