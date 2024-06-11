// data/weather_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApi {
  static Future<Map<String, dynamic>> getWeatherData(
      String city, String apiKey) async {
    String currentWeatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    http.Response currentWeatherResponse =
        await http.get(Uri.parse(currentWeatherUrl));
    Map<String, dynamic> currentWeatherData =
        json.decode(currentWeatherResponse.body);

    String forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';
    http.Response forecastResponse = await http.get(Uri.parse(forecastUrl));
    Map<String, dynamic> forecastData = json.decode(forecastResponse.body);

    return {'current': currentWeatherData, 'forecast': forecastData};
  }
}
