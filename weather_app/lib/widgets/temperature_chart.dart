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

                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(hours.length, (i) {
                            return FlSpot(i.toDouble(), hours[i].temperature);
                          }),
                          isCurved: true,
                          color: Colors.white,
                          barWidth: 3,
                          dotData: FlDotData(show: false),
                        ),
                      ],
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
