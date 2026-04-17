String getWeatherDescription(int weatherCode) {
  switch (weatherCode) {
    case 0:
      return 'Clear sky';
    case 1:
    case 2:
    case 3:
      return 'Partly cloudy';
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
    default:
      return 'Unknown weather code: $weatherCode';
  }
}


String getWeatherAnimation(int weatherCode) {
  if (weatherCode == 0) {
    return 'assets/animations/sunny.json';
  } else if (weatherCode >= 1 && weatherCode <= 3) {
    return 'assets/animations/partly_cloudy.json';
  } else if (weatherCode == 45 || weatherCode == 48) {
    return 'assets/animations/fog.json';
  } else if ((weatherCode >= 51 && weatherCode <= 67) || weatherCode >= 80 && weatherCode <= 82) {
    return 'assets/animations/rain.json';
  } else if ((weatherCode >= 71 && weatherCode <= 77) || weatherCode >= 85 && weatherCode <= 86) {
    return 'assets/animations/snow.json';
  } else {
    return 'assets/animations/partly_cloudy.json'; // default animation for unknown codes
  }
}

// Get icons from Icons library for weather codes
