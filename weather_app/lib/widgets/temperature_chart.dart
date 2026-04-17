import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/hourly_weather.dart';

class TemperatureChart extends StatefulWidget {
  final List<HourlyWeather> hours;

  const TemperatureChart({super.key, required this.hours});

  @override
  State<TemperatureChart> createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<TemperatureChart> {
  static const double _tempBuffer = 2.0;
  static const double _yAxisInterval = 2.0;
  static const int _stepsPerSegment = 5;

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

  List<HourlyWeather>? _lastHoursRef;
  List<LineChartBarData> _cachedBars = <LineChartBarData>[];
  double _cachedMinY = 0;
  double _cachedMaxY = 0;
  double _cachedMaxX = 0;
  bool _hasData = false;

  @override
  void initState() {
    super.initState();
    _recomputeChartData(force: true);
  }

  @override
  void didUpdateWidget(covariant TemperatureChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _recomputeChartData();
  }

  void _recomputeChartData({bool force = false}) {
    if (!force && identical(_lastHoursRef, widget.hours)) {
      return;
    }

    _lastHoursRef = widget.hours;
    final hours = widget.hours;

    if (hours.isEmpty) {
      _hasData = false;
      _cachedBars = <LineChartBarData>[];
      _cachedMinY = 0;
      _cachedMaxY = 0;
      _cachedMaxX = 0;
      return;
    }

    _hasData = true;
    _cachedMaxX = (hours.length - 1).toDouble();

    double rawMin = hours.first.temperature;
    double rawMax = hours.first.temperature;

    for (int i = 1; i < hours.length; i++) {
      final temp = hours[i].temperature;
      if (temp < rawMin) {
        rawMin = temp;
      }
      if (temp > rawMax) {
        rawMax = temp;
      }
    }

    final bufferedMin = rawMin - _tempBuffer;
    final bufferedMax = rawMax + _tempBuffer;
    _cachedMinY = (bufferedMin / 2).floorToDouble() * 2;
    _cachedMaxY = (bufferedMax / 2).ceilToDouble() * 2;
    _cachedBars = _buildGradientBars(hours);
  }

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

  List<LineChartBarData> _buildGradientBars(List<HourlyWeather> hours) {
    final bars = <LineChartBarData>[];
    final invSteps = 1.0 / _stepsPerSegment;

    for (int i = 0; i < hours.length - 1; i++) {
      final t1 = hours[i].temperature;
      final t2 = hours[i + 1].temperature;

      for (int s = 0; s < _stepsPerSegment; s++) {
        final t = s * invSteps;
        final tNext = (s + 1) * invSteps;

        final tempA = t1 + (t2 - t1) * t;
        final tempB = t1 + (t2 - t1) * tNext;
        final xA = i + t;
        final xB = i + tNext;

        final colorA = _getColorForTemp(tempA);
        final colorB = _getColorForTemp(tempB);

        bars.add(
          LineChartBarData(
            spots: [FlSpot(xA, tempA), FlSpot(xB, tempB)],
            isCurved: false,
            barWidth: 3,
            dotData: FlDotData(show: false),
            gradient: LinearGradient(colors: [colorA, colorB]),
          ),
        );
      }
    }

    return bars;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasData) {
      return const SizedBox();
    }
    final hours = widget.hours;

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
                  child: RepaintBoundary(
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: _cachedMaxX,
                        minY: _cachedMinY,
                        maxY: _cachedMaxY,
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval: _yAxisInterval,
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
                        lineBarsData: _cachedBars,
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
