import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/daily_weather.dart';

class DailyTemperatureChart extends StatelessWidget {
  final List<DailyWeather> days;

  const DailyTemperatureChart({super.key, required this.days});

  static const double _tempBuffer = 2.0;
  static const double _yAxisInterval = 5.0;

  List<FlSpot> _buildMinSpots() {
    return List<FlSpot>.generate(
      days.length,
      (i) => FlSpot(i.toDouble(), days[i].minTemp),
    );
  }

  List<FlSpot> _buildMaxSpots() {
    return List<FlSpot>.generate(
      days.length,
      (i) => FlSpot(i.toDouble(), days[i].maxTemp),
    );
  }

  String _dayLabel(DateTime date) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return const SizedBox();
    }

    double rawMin = days.first.minTemp;
    double rawMax = days.first.maxTemp;

    for (int i = 1; i < days.length; i++) {
      final day = days[i];
      if (day.minTemp < rawMin) {
        rawMin = day.minTemp;
      }
      if (day.maxTemp > rawMax) {
        rawMax = day.maxTemp;
      }
    }

    final minY =
        ((rawMin - _tempBuffer) / _yAxisInterval).floorToDouble() *
        _yAxisInterval;
    final maxY =
        ((rawMax + _tempBuffer) / _yAxisInterval).ceilToDouble() *
        _yAxisInterval;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '7-Day temperatures',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (days.length - 1).toDouble(),
                  minY: minY,
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: _yAxisInterval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.18),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.white.withOpacity(0.08),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= days.length) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              _dayLabel(days[index].date),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: _yAxisInterval,
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
                      spots: _buildMaxSpots(),
                      isCurved: true,
                      barWidth: 2.5,
                      color: const Color.fromARGB(255, 255, 151, 82),
                      dotData: FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: _buildMinSpots(),
                      isCurved: true,
                      barWidth: 2.5,
                      color: Colors.lightBlueAccent,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(
                color: const Color.fromARGB(255, 255, 151, 82),
                label: 'Max temperature',
              ),
              const SizedBox(width: 16),
              const _LegendItem(
                color: Colors.lightBlueAccent,
                label: 'Min temperature',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
