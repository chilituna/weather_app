import 'package:flutter/material.dart';
import '../models/daily_weather.dart';
import '../models/location.dart';
import '../utils/weather_utils.dart';
import '../widgets/daily_temperature_chart.dart';

class Weekly extends StatefulWidget {
  final LocationData? locationData;
  final List<DailyWeather>? dailyWeather;

  const Weekly({
    super.key,
    required this.locationData,
    required this.dailyWeather,
  });

  @override
  State<Weekly> createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> {
  final ScrollController _weeklyScrollController = ScrollController();

  @override
  void dispose() {
    _weeklyScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dailyWeather == null || widget.dailyWeather!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final firstDate = widget.dailyWeather!.first.date;
    final startDateOnly = DateTime(
      firstDate.year,
      firstDate.month,
      firstDate.day,
    );

    final next7Days = widget.dailyWeather!
        .where((d) {
          final dateOnly = DateTime(d.date.year, d.date.month, d.date.day);
          return !dateOnly.isBefore(startDateOnly);
        })
        .take(7)
        .toList();

    if (next7Days.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
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
            SizedBox(
              height: 280,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DailyTemperatureChart(days: next7Days),
              ),
            ),

            const SizedBox(height: 30),

            // Scrollable list of daily forecasts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 160,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 0.35),
                  borderRadius: BorderRadius.circular(16),
                ),
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
                    controller: _weeklyScrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: _weeklyScrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: next7Days.length,
                      itemExtent: 120,
                      itemBuilder: (context, index) {
                        final day = next7Days[index];

                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                _formatDate(day.date),
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              getWeatherIcon(day.weatherCode, size: 38),
                              const SizedBox(height: 8),
                              Text(
                                'Max ${day.maxTemp.toStringAsFixed(0)}°C',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 151, 82),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Min ${day.minTemp.toStringAsFixed(0)}°C',
                                style: const TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        );
                      },
                    ),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';

    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return 'Today $formattedDate';
    }

    const shortWeekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${shortWeekdays[date.weekday - 1]} $formattedDate';
  }
}
