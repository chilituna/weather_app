import 'package:flutter/material.dart';
import '../models/hourly_weather.dart';
import '../models/location.dart';
import '../utils/weather_utils.dart';
import '../widgets/temperature_chart.dart';

class Today extends StatefulWidget {
  final LocationData? locationData;
  final List<HourlyWeather>? hourlyWeather;

  const Today({
    super.key,
    required this.locationData,
    required this.hourlyWeather,
  });

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  final ScrollController _hourlyScrollController = ScrollController();

  @override
  void dispose() {
    _hourlyScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // today's weather is the hourly weather for the current day, from 0:00 to 23:00
    final today = DateTime.now();
    final todayHours = (widget.hourlyWeather ?? [])
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
            if (widget.locationData != null) ...[
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      widget.locationData!.city,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${widget.locationData!.region}, ${widget.locationData!.country}',
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

            const SizedBox(height: 30),

            // ↔️ Horizontal hourly list
            Container(
              width: double.infinity,
              height: 160,
              color: const Color.fromRGBO(0, 0, 0, 0.35),
              child: ScrollbarTheme(
                data: const ScrollbarThemeData(
                  thumbColor: MaterialStatePropertyAll(Colors.orange),
                  trackColor: MaterialStatePropertyAll(Colors.transparent),
                  trackBorderColor: MaterialStatePropertyAll(
                    Colors.transparent,
                  ),
                  thickness: MaterialStatePropertyAll(6),
                  radius: Radius.zero,
                  crossAxisMargin: 0,
                  mainAxisMargin: 6,
                ),
                child: Scrollbar(
                  controller: _hourlyScrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: _hourlyScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: todayHours.length,
                    itemExtent: 120,
                    itemBuilder: (context, index) {
                      final hour = todayHours[index];

                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${hour.time.hour.toString().padLeft(2, '0')}:00',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            getWeatherIcon(hour.weatherCode, size: 40),
                            const SizedBox(height: 8),
                            Text(
                              '${hour.temperature.toStringAsFixed(0)}°C',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Wind
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.air,
                                  color: Colors.white70,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${hour.windSpeed} km/h',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
