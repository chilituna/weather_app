import 'package:flutter/material.dart';
import '../models/hourly_weather.dart';
import '../models/location.dart';
import '../utils/weather_utils.dart';
import '../widgets/temperature_chart.dart';

class Today extends StatelessWidget {
  final LocationData? locationData;
  final List<HourlyWeather>? hourlyWeather;

  const Today({
    super.key,
    required this.locationData,
    required this.hourlyWeather,
  });

  @override
  Widget build(BuildContext context) {
    // today's weather is the hourly weather for the current day, from 0:00 to 23:00
    final today = DateTime.now();
    final todayHours = (hourlyWeather ?? [])
        .where(
          (h) =>
              h.time.year == today.year &&
              h.time.month == today.month &&
              h.time.day == today.day,
        )
        .toList();

    if (todayHours.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Location + title
            if (locationData != null) ...[
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      locationData!.city,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${locationData!.region}, ${locationData!.country}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],

             const SizedBox(height: 24),

            // Temperature Chart
            SizedBox(
              height: 280,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TemperatureChart(hours: todayHours),
              ),
            ),

            const SizedBox(height: 24),

            // ↔️ Horizontal hourly list
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: todayHours.length,
                itemBuilder: (context, index) {
                  final hour = todayHours[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${hour.time.hour.toString().padLeft(2, '0')}:00',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${hour.temperature.toStringAsFixed(0)}°',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          getWeatherDescription(hour.weatherCode),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
