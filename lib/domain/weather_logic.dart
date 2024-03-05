import 'package:flutter/material.dart';

class WeatherLogic {
  static IconData getWeatherIcon(String weatherMain) {
    switch (weatherMain) {
      case 'Clear':
        return Icons.wb_sunny;
      case 'Clouds':
        return Icons.cloud;
      case 'Rain':
        return Icons.beach_access;
      case 'Snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
  }
}
