import 'package:flutter/material.dart';

String getWeatherDescription(int weatherCode) {
  switch (weatherCode) {
    case 0:
      return 'Clear sky';
    case 1:
    case 2:
      return 'Partly cloudy';
    case 3:
      return 'Overcast';
    case 45:
    case 48:
      return 'Fog';
    case 51:
    case 53:
    case 55:
      return 'Drizzle';
    case 56:
    case 57:
      return 'Freezing Drizzle';
    case 61:
    case 63:
    case 65:
      return 'Rain';
    case 66:
    case 67:
      return 'Freezing Rain';
    case 71:
    case 73:
    case 75:
      return 'Snow fall';
    case 77:
      return 'Snow grains';
    case 80:
    case 81:
    case 82:
      return 'Rain showers';
    case 85:
    case 86:
      return 'Snow showers';
    case 95:
    case 96:
    case 99:
      return 'Thunderstorm';
    default:
      return 'Unknown weather code: $weatherCode';
  }
}


String getWeatherAnimation(int weatherCode) {
  if (weatherCode == 0) {
    return 'assets/animations/sunny.json';
  } else if (weatherCode >= 1 && weatherCode <= 2) {
    return 'assets/animations/partly_cloudy.json';
  } else if (weatherCode == 3) {
    return 'assets/animations/cloudy.json';
  } else if (weatherCode == 45 || weatherCode == 48) {
    return 'assets/animations/fog.json';
  } else if ((weatherCode >= 51 && weatherCode <= 67) || weatherCode >= 80 && weatherCode <= 82) {
    return 'assets/animations/rain.json';
  } else if ((weatherCode >= 71 && weatherCode <= 77) || weatherCode >= 85 && weatherCode <= 86) {
    return 'assets/animations/snow.json';
  } else if (weatherCode == 95 || weatherCode == 96 || weatherCode == 99) {
    return 'assets/animations/thunderstorm.json';
  } else {
    return 'assets/animations/partly_cloudy.json'; // default animation for unknown codes
  }
}

class PartlyCloudyIcon extends StatelessWidget {
  final double size;

  const PartlyCloudyIcon({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ☀️ Sun (behind)
          Positioned(
            top: size * 0.05,
            left: size * 0.05,
            child: Icon(
              Icons.wb_sunny,
              color: Colors.amber,
              size: size * 0.7,
            ),
          ),

          // ☁️ Cloud (front)
          Positioned(
            bottom: 0,
            right: 0,
            child: Icon(
              Icons.cloud,
              color: Colors.lightBlue,
              size: size * 0.75,
            ),
          ),
        ],
      ),
    );
  }
}

// Get icons from Icons library for weather codes
Widget getWeatherIcon(int weatherCode, {double size = 32}) {
  if (weatherCode == 0) {
    return Icon(Icons.wb_sunny, size: size, color: Colors.amber);
  } else if (weatherCode >= 1 && weatherCode <= 2) {
    return PartlyCloudyIcon(size: size); // ✅ now valid
  } else if (weatherCode == 3) {
    return Icon(Icons.cloud, size: size, color: Colors.lightBlue);
  } else if (weatherCode == 45 || weatherCode == 48) {
    return Icon(Icons.foggy, size: size, color: Colors.grey);
  } else if ((weatherCode >= 51 && weatherCode <= 67) ||
             (weatherCode >= 80 && weatherCode <= 82)) {
    return Icon(Icons.water_drop, size: size, color: Colors.blue);
  } else if ((weatherCode >= 71 && weatherCode <= 77) ||
             (weatherCode >= 85 && weatherCode <= 86)) {
    return Icon(Icons.ac_unit, size: size, color: Colors.lightBlueAccent);
  } else if (weatherCode == 95 || weatherCode == 96 || weatherCode == 99) {
    return Icon(Icons.flash_on, size: size, color: Colors.yellow);
  } else {
    return Icon(Icons.help_outline, size: size);
  }
}

Color getWeatherIconColor(int weatherCode) {
  if (weatherCode == 0) {
    return Colors.amber;
  } else if (weatherCode >= 1 && weatherCode <= 3) {
    return Colors.blueGrey;
  } else if (weatherCode == 45 || weatherCode == 48) {
    return Colors.grey;
  } else if ((weatherCode >= 51 && weatherCode <= 67) ||
      (weatherCode >= 80 && weatherCode <= 82)) {
    return Colors.blue;
  } else if ((weatherCode >= 71 && weatherCode <= 77) ||
      (weatherCode >= 85 && weatherCode <= 86)) {
    return Colors.lightBlueAccent;
  } else if (weatherCode == 95 || weatherCode == 96 || weatherCode == 99) {
    return Colors.yellow.shade700;
  } else {
    return Colors.white70;
  }
}