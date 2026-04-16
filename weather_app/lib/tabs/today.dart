import 'package:flutter/material.dart';
import '../models/hourly_weather.dart';
import '../models/location.dart';
import '../utils/weather_utils.dart';

class Today extends StatelessWidget {
  final LocationData? locationData;
  final List<HourlyWeather>? hourlyWeather;


  const Today({super.key, required this.locationData, required this.hourlyWeather});


  @override
  Widget build(BuildContext context) {
    // today's weather is the hourly weather for the current day, from 0:00 to 23:00
    final today = DateTime.now();
    final todayHours = (hourlyWeather ?? [])
        .where((h) =>
            h.time.year == today.year &&
            h.time.month == today.month &&
            h.time.day == today.day)
        .toList();

    return Column(
      children: [
        // Location + title
        const SizedBox(height: 16),

        const Text(
          'Forecast for today',
          style: TextStyle(fontSize: 24),
        ),

        if (locationData != null) ...[
          const SizedBox(height: 8),
          Text(locationData!.city),
          Text('${locationData!.region}, ${locationData!.country}'),
        ],

        const SizedBox(height: 16),

        // scrollable list of hourly weather from 0:00 to 23:00
        Expanded(
          child: ListView.builder(
            itemCount: todayHours.length,
            itemBuilder: (context, index) {
              final hourWeather = todayHours[index];

              return ListTile(
                title: Text('${hourWeather.time.hour}:00'),
                subtitle: Text('${hourWeather.temperature}°C Wind: ${hourWeather.windSpeed} km/h' ),
                trailing: Text(
                  getWeatherDescription(hourWeather.weatherCode),

                ),
              );
            },
          ),
        ),
      ],
    );
  }
}