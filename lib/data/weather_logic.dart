import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherLogic {
  String city;
  String apiKey;

  WeatherLogic(this.city, this.apiKey);

  Future<Map<String, dynamic>> getWeatherData() async {
    String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    http.Response response = await http.get(Uri.parse(apiUrl));
    return json.decode(response.body);
  }
}
