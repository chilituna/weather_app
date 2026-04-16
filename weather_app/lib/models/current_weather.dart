class CurrentWeather {
  final double temperature; // in celsius
  final double windSpeed; // in km/h
  final int weatherCode; // Open-Meteo weather code

  CurrentWeather({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
  });
}
