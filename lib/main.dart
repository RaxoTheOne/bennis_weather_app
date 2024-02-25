import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(MyWeatherApp());
}

class MyWeatherApp extends StatefulWidget {
  @override
  _MyWeatherAppState createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> {
  String _city = 'Berlin'; // Ändere die Stadt hier nach Bedarf
  String _apiKey =
      '4802adcc2b0a6db427173599dbaa9d4e'; // Füge hier deinen API-Schlüssel ein

  Future<Map<String, dynamic>> getWeatherData() async {
    String currentWeatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$_apiKey&units=metric';
    http.Response currentWeatherResponse =
        await http.get(Uri.parse(currentWeatherUrl));
    Map<String, dynamic> currentWeatherData =
        json.decode(currentWeatherResponse.body);

    String forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$_city&appid=$_apiKey&units=metric';
    http.Response forecastResponse = await http.get(Uri.parse(forecastUrl));
    Map<String, dynamic> forecastData = json.decode(forecastResponse.body);

    return {'current': currentWeatherData, 'forecast': forecastData};
  }

  IconData getWeatherIcon(String weatherMain) {
    switch (weatherMain) {
      case 'Clear':
        return Icons.wb_sunny;
      case 'Clouds':
        return Icons.cloud;
      case 'Rain':
        return Icons.beach_access; // Du kannst das Symbol nach Bedarf ändern
      case 'Snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Wettervorhersage'),
        ),
        body: Center(
          child: FutureBuilder(
            future: getWeatherData(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                Map<String, dynamic>? weatherData = snapshot.data;
                if (weatherData == null) {
                  return Text('No data available');
                }
                Map<String, dynamic> currentWeatherData =
                    weatherData['current'];
                Map<String, dynamic> forecastData = weatherData['forecast'];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Aktuelles Wetter in $_city:',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Icon(
                      getWeatherIcon(currentWeatherData['weather'][0]['main']),
                      size: 50,
                    ),
                    Text(
                      '${currentWeatherData['weather'][0]['main']}',
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      'Temperatur: ${currentWeatherData['main']['temp']}°C',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Vorhersage für die nächsten Tage:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: forecastData['list'].length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> forecast =
                              forecastData['list'][index];
                          DateTime dateTime =
                              DateTime.fromMillisecondsSinceEpoch(
                                  forecast['dt'] * 1000);
                          String date =
                              DateFormat('dd.MM.yyyy').format(dateTime);
                          String time = DateFormat('HH:mm').format(dateTime);
                          String forecastMain = forecast['weather'][0]['main'];
                          double forecastTemp =
                              forecast['main']['temp'].toDouble();
                          return Card(
                            child: ListTile(
                              leading: Icon(getWeatherIcon(forecastMain)),
                              title: Text(
                                '$date $time',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  '$forecastMain, $forecastTemp°C'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
