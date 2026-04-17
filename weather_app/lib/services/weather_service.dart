// uses open-meteo weather API to fetch current, hourly, and daily weather data based on lat and lon
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/current_weather.dart';
import '../models/hourly_weather.dart';
import '../models/daily_weather.dart';

class WeatherService {
  Future<
    ({
      CurrentWeather? currentWeather,
      List<HourlyWeather>? hourlyWeather,
      List<DailyWeather>? dailyWeather,
    })
  >
  getWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$lat'
        '&longitude=$lon'
        '&current_weather=true'
        '&hourly=temperature_2m,weathercode,windspeed_10m'
        '&daily=temperature_2m_max,temperature_2m_min,'
        'weathercode,windspeed_10m_max&timezone=auto',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch weather data');
    }

    final data = json.decode(response.body);

    // CURRENT
    final current = CurrentWeather(
      temperature: data['current_weather']['temperature'].toDouble(),
      windSpeed: data['current_weather']['windspeed'].toDouble(),
      weatherCode: data['current_weather']['weathercode'],
    );

    // HOURLY
    final List times = data['hourly']['time'];
    final List temps = data['hourly']['temperature_2m'];
    final List codes = data['hourly']['weathercode'];
    final List winds = data['hourly']['windspeed_10m'];

    final hourly = List.generate(times.length, (i) {
      return HourlyWeather(
        time: DateTime.parse(times[i]),
        temperature: temps[i].toDouble(),
        weatherCode: codes[i],
        windSpeed: winds[i].toDouble(),
      );
    });

    // DAILY
    final List dates = data['daily']['time'];
    final List minTemps = data['daily']['temperature_2m_min'];
    final List maxTemps = data['daily']['temperature_2m_max'];
    final List dailyCodes = data['daily']['weathercode'];

    final daily = List.generate(dates.length, (i) {
      return DailyWeather(
        date: DateTime.parse(dates[i]),
        minTemp: minTemps[i].toDouble(),
        maxTemp: maxTemps[i].toDouble(),
        weatherCode: dailyCodes[i],
      );
    });

    return (
      currentWeather: current,
      hourlyWeather: hourly,
      dailyWeather: daily,
    );
  }
}
