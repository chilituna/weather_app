import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart' as lottie;
import '../models/current_weather.dart';
import '../models/location.dart';
import '../utils/weather_utils.dart';

class Currently extends StatelessWidget {
  final LocationData? locationData;
  final CurrentWeather? currentWeather;

  const Currently({
    super.key,
    required this.currentWeather,
    required this.locationData,
  });

  @override
Widget build(BuildContext context) {
  return SafeArea(
    child: Center(
      child: currentWeather == null
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Location
                  if (locationData != null) ...[
                    Text(
                      locationData!.city,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${locationData!.region}, ${locationData!.country}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Temperature
                  Text(
                    '${currentWeather!.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  // Animation
                  lottie.LottieBuilder.asset(
                    getWeatherAnimation(currentWeather!.weatherCode),
                    width: 250,
                    height: 250,
                  ),

                  // Description
                  Text(
                    getWeatherDescription(currentWeather!.weatherCode),
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Wind
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.air, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(
                    '${currentWeather!.windSpeed} km/h',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
