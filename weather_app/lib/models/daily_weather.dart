// daily weather for the next 7 days, including min and max temperatures, and a brief description of the weather conditions (e.g., cloudy, sunny, rainy).

class DailyWeather {
  final DateTime date;
  final double minTemp; // in celsius
  final double maxTemp; // in celsius
  final int weatherCode; // Open-Meteo weather code

  DailyWeather({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.weatherCode,
  });
}