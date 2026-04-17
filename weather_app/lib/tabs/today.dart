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
    // today's weather is the hourly weather for the current day in the location's timezone
    // We extract the date part from each timestamp and find all entries from the earliest date
    if (widget.hourlyWeather == null || widget.hourlyWeather!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Get the date of the first hourly entry (represents "today" in the location)
    final firstDate = widget.hourlyWeather!.first.time;
    final todayDateStr =
        '${firstDate.year.toString().padLeft(4, '0')}-${firstDate.month.toString().padLeft(2, '0')}-${firstDate.day.toString().padLeft(2, '0')}';

    final todayHours = widget.hourlyWeather!.where((h) {
      final hourDateStr =
          '${h.time.year.toString().padLeft(4, '0')}-${h.time.month.toString().padLeft(2, '0')}-${h.time.day.toString().padLeft(2, '0')}';
      return hourDateStr == todayDateStr;
    }).toList();

    final nextMidnight = widget.hourlyWeather!.cast<HourlyWeather?>().firstWhere(
      (h) =>
          h != null &&
          h.time.hour == 0 &&
          '${h.time.year.toString().padLeft(4, '0')}-${h.time.month.toString().padLeft(2, '0')}-${h.time.day.toString().padLeft(2, '0')}' !=
              todayDateStr,
      orElse: () => null,
    );

    final chartHours = <HourlyWeather>[
      ...todayHours,
      if (nextMidnight != null) nextMidnight,
    ];

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
                child: TemperatureChart(hours: chartHours),
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
