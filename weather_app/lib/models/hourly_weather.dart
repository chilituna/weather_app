
// weather details for each hour of the day, from 0:00 to 23:00

class HourlyWeather {
  final DateTime time;
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final bool isDay;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.isDay,
  });

}