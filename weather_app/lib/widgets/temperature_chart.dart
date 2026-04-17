import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/hourly_weather.dart';

class TemperatureChart extends StatelessWidget {
  final List<HourlyWeather> hours;

  const TemperatureChart({super.key, required this.hours});

  @override
  Widget build(BuildContext context) {
    if (hours.isEmpty) {
      return const SizedBox();
    }

    final temps = hours.map((e) => e.temperature).toList();

    final rawMin = temps.reduce((a, b) => a < b ? a : b);
    final rawMax = temps.reduce((a, b) => a > b ? a : b);

    // add buffer
    final bufferedMin = rawMin - 2;
    final bufferedMax = rawMax + 2;

    // round to even numbers
    final minY = (bufferedMin / 2).floor() * 2;
    final maxY = (bufferedMax / 2).ceil() * 2;

    // Keep Y ticks predictable so each 2-degree step is printed.
    const yAxisInterval = 2.0;

    Color getColorForTemp(double temp) {
      // Define anchor points
      final stops = [
        -25.0,
        -15.0,
        -5.0,
        5.0,
        15.0,
        25.0,
        35.0,
      ];

      final colors = [
        Colors.blue.shade900,
        Colors.blue,
        Colors.lightBlue,
        Colors.amber,
        Colors.orange,
        Colors.red,
        Colors.red.shade900,
      ];

      // Clamp temp into range
      temp = temp.clamp(stops.first, stops.last);

      // Find interval
      for (int i = 0; i < stops.length - 1; i++) {
        final t1 = stops[i];
        final t2 = stops[i + 1];

        if (temp >= t1 && temp <= t2) {
          final ratio = (temp - t1) / (t2 - t1);
          return Color.lerp(colors[i], colors[i + 1], ratio)!;
        }
      }

      return colors.last;
    }

    final List<LineChartBarData> bars = [];

    const stepsPerSegment = 5;

    for (int i = 0; i < hours.length - 1; i++) {
      final t1 = hours[i].temperature;
      final t2 = hours[i + 1].temperature;

      for (int s = 0; s < stepsPerSegment; s++) {
        final t = s / stepsPerSegment;
        final tNext = (s + 1) / stepsPerSegment;

        // interpolate temperature
        final tempA = t1 + (t2 - t1) * t;
        final tempB = t1 + (t2 - t1) * tNext;

        // interpolate X position
        final xA = i + t;
        final xB = i + tNext;

        final colorA = getColorForTemp(tempA);
        final colorB = getColorForTemp(tempB);

        bars.add(
          LineChartBarData(
            spots: [
              FlSpot(xA, tempA),
              FlSpot(xB, tempB),
            ],
            isCurved: false,
            barWidth: 3,
            dotData: FlDotData(show: false),

            gradient: LinearGradient(
              colors: [colorA, colorB],
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.35),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Today temperatures',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: (hours.length - 1).toDouble(),
                      minY: minY.toDouble(),
                      maxY: maxY.toDouble(),
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: yAxisInterval,
                      ),
                      borderData: FlBorderData(show: false),

                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 3,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= hours.length) {
                                return const SizedBox();
                              }

                              final hour = hours[index].time.hour;

                              return Text(
                                '${hour.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),

                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: yAxisInterval,
                            reservedSize: 34,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}°',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),

                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      lineBarsData: bars,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
