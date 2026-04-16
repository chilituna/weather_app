// Converts latitude and longitude to a city name using a geocoding API.
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location.dart';

class GeocodingService {

  // reverse geocoding: lat/lon to city name
  Future<LocationData> getLocationData(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$lat&longitude=$lon&localityLanguage=en',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch location data');
    }

    final data = json.decode(response.body);

    if (data == null || data.isEmpty) {
      throw Exception('No location data found');
    }

    return LocationData(
      city: data['city'] ?? 'Unknown',
      region: data['principalSubdivision'] ?? '',
      country: data['countryName'] ?? 'Unknown',
      lat: lat,
      lon: lon,
    );
  }

  // forward geocoding: city name to lat/lon
  Future<List<LocationData>> searchCity(String query) async {
  if (query.isEmpty) return [];

  final url = Uri.parse(
    'https://geocoding-api.open-meteo.com/v1/search?name=$query&count=5',
  );

  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception('Failed to search city');
  }

  final data = jsonDecode(response.body);

  if (data['results'] == null) return [];

  return (data['results'] as List).map((item) {
    return LocationData(
      city: item['name'] ?? 'Unknown',
      region: item['admin1'] ?? '',
      country: item['country'] ?? 'Unknown',
      lat: item['latitude'],
      lon: item['longitude'],
    );
  }).toList();
}
}
