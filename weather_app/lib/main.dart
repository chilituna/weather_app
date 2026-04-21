import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Outfit',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.w700,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.w700,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.w700,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.w700,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Merriweather',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
