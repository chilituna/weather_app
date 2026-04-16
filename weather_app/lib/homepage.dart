import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' show ClientException;

import 'dart:async';

import 'tabs/currently.dart';
import 'tabs/today.dart';
import 'tabs/weekly.dart';

import 'models/location.dart';
import 'models/current_weather.dart';
import 'models/hourly_weather.dart';
import 'models/daily_weather.dart';

import 'services/location_service.dart';
import 'services/geocoding_service.dart';
import 'services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _locationError;

  LocationData? _locationData;
  CurrentWeather? _currentWeather;
  List<HourlyWeather>? _hourlyWeather;
  List<DailyWeather>? _dailyWeather;

  final TextEditingController _searchController = TextEditingController();
  List<LocationData> _searchResults = [];
  Timer? _debounce;
  String _lastQuery = '';

  String _toUserMessage(Object error) {
    final raw = error.toString();
    if (error is ClientException ||
        raw.contains('Failed to fetch') ||
        raw.contains('SocketException')) {
      return 'Service connection is lost. Check your internet and try again.';
    }
    return raw;
  }

  // Search for location based on user input
  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    try {
      final results = await GeocodingService().searchCity(query);
      if (query != _lastQuery) return;
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _locationError = _toUserMessage(e);
      });
    }
  }

  // Debounce search input to avoid excessive API calls
  void _onSearchChanged(String query) {
    _lastQuery = query;

    // cancel previous timer
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    // start new timer
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (query.length < 2) {
        setState(() => _searchResults = []);
        return;
      }

      _searchLocation(query);
    });
  }

  // When user selects a city from search results, fetch weather data for that location
  Future<void> _selectCity(LocationData city) async {
    setState(() {
      _searchResults = [];
      _searchController.clear();
      _locationError = null;
    });

    try {
      final weather = await WeatherService().getWeather(city.lat, city.lon);

      setState(() {
        _locationData = city;
        _currentWeather = weather.currentWeather;
        _hourlyWeather = weather.hourlyWeather;
        _dailyWeather = weather.dailyWeather;
      });
    } catch (e) {
      setState(() {
        _locationError = _toUserMessage(e);
      });
    }
  }

  // Fetch location and weather data based on current position
  Future<void> _getLocation() async {
    setState(() {
      _locationError = null;
    });

    try {
      final position = await LocationService().getCurrentLocation();
      final locationData = await GeocodingService().getLocationData(
        position.latitude,
        position.longitude,
      );

      final weatherData = await WeatherService().getWeather(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _locationData = locationData;
        _currentWeather = weatherData.currentWeather;
        _hourlyWeather = weatherData.hourlyWeather;
        _dailyWeather = weatherData.dailyWeather;
      });
    } catch (e) {
      setState(() {
        _locationError =
            '${_toUserMessage(e)}\n\nUse the search bar to find a city.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.search),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  inputFormatters: [LengthLimitingTextInputFormatter(30)],
                  decoration: InputDecoration(
                    hintText: 'Search location',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    _onSearchChanged(value);
                  },
                  onSubmitted: (value) async {
                    // Ensure we have up-to-date results
                    await _searchLocation(value);

                    if (_searchResults.isNotEmpty) {
                      _selectCity(_searchResults.first);
                    } else {
                      setState(() {
                        _locationError = 'No location found for "$value"';
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          actions: [
            IconButton(icon: Icon(Icons.my_location), onPressed: _getLocation),
          ],
          backgroundColor: const Color.fromARGB(220, 52, 221, 199),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.7,
                  child: Image.asset('lib/assets/bg.png', fit: BoxFit.cover),
                ),
              ),
            ),
            if (_locationError != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _locationError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              )
            else
              TabBarView(
                children: [
                  Currently(
                    locationData: _locationData,
                    currentWeather: _currentWeather,
                  ),
                  Today(
                    locationData: _locationData,
                    hourlyWeather: _hourlyWeather,
                  ),
                  Weekly(
                    locationData: _locationData,
                    dailyWeather: _dailyWeather,
                  ),
                ],
              ),
            if (_searchResults.isNotEmpty)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final city = _searchResults[index];

                      return ListTile(
                        title: Text(city.city),
                        subtitle: Text('${city.region}, ${city.country}'),
                        onTap: () => _selectCity(city),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.cloud), text: 'Currently'),
            Tab(icon: Icon(Icons.today), text: 'Today'),
            Tab(icon: Icon(Icons.view_week), text: 'Weekly'),
          ],
        ),
      ),
    );
  }
}
