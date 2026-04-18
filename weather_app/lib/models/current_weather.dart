class CurrentWeather {
  final double temperature; // in celsius
  final double windSpeed; // in km/h
  final int weatherCode; // Open-Meteo weather code
  final bool isDay; // true during daytime, false between sunset and sunrise

  CurrentWeather({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.isDay,
  });
}
