import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/hourly_weather.dart';

class TemperatureChart extends StatelessWidget {
  final List<HourlyWeather> hours;

  const TemperatureChart({super.key, required this.hours});
  static const double _tempBuffer = 2.0;
  static const double _yAxisInterval = 2.0;
  static const double _xAxisInterval = 3.0;

  static const List<double> _tempStops = [
    -25.0,
    -10.0,
    5.0,
    10.0,
    20.0,
    30.0,
    35.0,
  ];

  static final List<Color> _tempColors = [
    Colors.blue.shade900,
    Colors.blue,
    Colors.lightBlue,
    Colors.amber,
    Colors.orange,
    Colors.red,
    Colors.red.shade900,
  ];

  static Color _getColorForTemp(double temp) {
    temp = temp.clamp(_tempStops.first, _tempStops.last);

    for (int i = 0; i < _tempStops.length - 1; i++) {
      final t1 = _tempStops[i];
      final t2 = _tempStops[i + 1];

      if (temp >= t1 && temp <= t2) {
        final ratio = (temp - t1) / (t2 - t1);
        return Color.lerp(_tempColors[i], _tempColors[i + 1], ratio)!;
      }
    }

    return _tempColors.last;
  }

  static List<LineChartBarData> _buildLineChart(List<HourlyWeather> hours) {
    final spots = <FlSpot>[];
    final first = hours.first.time;
    final firstDateStr =
        '${first.year.toString().padLeft(4, '0')}-${first.month.toString().padLeft(2, '0')}-${first.day.toString().padLeft(2, '0')}';

    for (int i = 0; i < hours.length; i++) {
      final time = hours[i].time;
      final dateStr =
          '${time.year.toString().padLeft(4, '0')}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
      final x = dateStr == firstDateStr ? time.hour.toDouble() : 24.0;
      spots.add(FlSpot(x, hours[i].temperature));
    }

    return [
      LineChartBarData(
        spots: spots,
        isCurved: false,
        barWidth: 2,
        color: Colors.amber,
        dotData: FlDotData(show: false),
      ),
    ];
  }

  static FlLine _getGridLineForTemp(double temp) {
    final color = _getColorForTemp(temp);
    return FlLine(color: color.withOpacity(0.5), strokeWidth: 1);
  }

  @override
  Widget build(BuildContext context) {
    if (hours.isEmpty) {
      return const SizedBox();
    }

    // Calculate temperature range
    double rawMin = hours.first.temperature;
    double rawMax = hours.first.temperature;

    for (int i = 1; i < hours.length; i++) {
      final temp = hours[i].temperature;
      if (temp < rawMin) rawMin = temp;
      if (temp > rawMax) rawMax = temp;
    }

    final bufferedMin = rawMin - _tempBuffer;
    final bufferedMax = rawMax + _tempBuffer;
    final minY = (bufferedMin / 2).floorToDouble() * 2;
    final maxY = (bufferedMax / 2).ceilToDouble() * 2;
    const minX = 0.0;
    const maxX = 24.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Today\'s temperatures',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: RepaintBoundary(
                    child: IgnorePointer(
                      child: LineChart(
                        LineChartData(
                          minX: minX,
                          maxX: maxX,
                          minY: minY,
                          maxY: maxY,
                          gridData: FlGridData(
                            show: true,
                            horizontalInterval: _yAxisInterval,
                            verticalInterval: _xAxisInterval,
                            getDrawingHorizontalLine: (value) {
                              return _getGridLineForTemp(value);
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: Colors.white.withOpacity(0.18),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          borderData: FlBorderData(show: false),

                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: _xAxisInterval,
                                getTitlesWidget: (value, meta) {
                                  if (value < minX || value > maxX) {
                                    return const SizedBox();
                                  }

                                  final hour = value.toInt();

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
                          lineBarsData: _buildLineChart(hours),
                        ),
                      ),
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
