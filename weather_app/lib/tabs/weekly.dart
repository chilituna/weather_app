import 'package:flutter/material.dart';
import '../models/daily_weather.dart';
import '../models/location.dart';
import '../utils/weather_utils.dart';

class Weekly extends StatelessWidget {
  final LocationData? locationData;
  final List<DailyWeather>? dailyWeather;


  const Weekly({super.key, required this.locationData, required this.dailyWeather});


  @override
  Widget build(BuildContext context) {
    // weekly weather shows 7 days overview
    final today = DateTime.now();
    final next7Days = (dailyWeather ?? [])
    .whereType<DailyWeather>()
    .where((d) =>
        !d.date.isBefore(DateTime(today.year, today.month, today.day)))
    .take(7)
    .toList();

    return Column(
      children: [
        const SizedBox(height: 16),

        const Text(
          'Weekly Forecast',
          style: TextStyle(fontSize: 24),
        ),

        if (locationData != null) ...[
          const SizedBox(height: 8),
          Text(locationData!.city),
          Text('${locationData!.region}, ${locationData!.country}'),
        ],
        const SizedBox(height: 16),

        //  Scrollable list
        Expanded(
          child: ListView.builder(
            itemCount: next7Days.length,
            itemBuilder: (context, index) {
              final day = next7Days[index];

              return ListTile(
                title: Text(_formatDate(day.date)),
                subtitle: Text(
                  'Min: ${day.minTemp}°C / Max: ${day.maxTemp}°C',
                ),
                trailing: Text(
                  getWeatherDescription(day.weatherCode),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();

    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Today';
    }

    return '${date.day}.${date.month}.${date.year}';
  }
}