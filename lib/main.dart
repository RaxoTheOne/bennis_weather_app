import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyWeatherApp());
}

class MyWeatherApp extends StatefulWidget {
  @override
  _MyWeatherAppState createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> {
  String _city = 'Berlin'; // Ändere die Stadt hier nach Bedarf
  String _apiKey = '4802adcc2b0a6db427173599dbaa9d4e'; // Füge hier deinen API-Schlüssel ein

  Future<Map<String, dynamic>> getWeatherData() async {
    String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$_apiKey&units=metric';
    http.Response response = await http.get(apiUrl as Uri);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Wettervorhersage'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: getWeatherData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> weatherData = snapshot.data;
                    return Column(
                      children: <Widget>[
                        Text(
                          'Aktuelles Wetter in $_city:',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${weatherData['weather'][0]['main']}',
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          'Temperatur: ${weatherData['main']['temp']}°C',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(height: 20),
              Text(
                'Vorhersage für die nächsten Tage:',
                style: TextStyle(fontSize: 20),
              ),
              // Hier kannst du die Vorhersage-Widgets hinzufügen
              // Zum Beispiel: ListView.builder für eine Liste von Vorhersagen
            ],
          ),
        ),
      ),
    );
  }
}