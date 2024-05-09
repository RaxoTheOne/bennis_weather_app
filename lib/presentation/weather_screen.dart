// presentation/weather_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:bennis_weather_app/domain/weather_logic.dart';

class MyWeatherApp extends StatefulWidget {
  @override
  _MyWeatherAppState createState() => _MyWeatherAppState();
}

class _MyWeatherAppState extends State<MyWeatherApp> {
  String _city = 'Berlin'; 
  String _apiKey = '4802adcc2b0a6db427173599dbaa9d4e'; 

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

  void _refreshWeatherData() {
    setState(() {
      // Hier kannst du zusätzliche Logik hinzufügen, z.B. eine andere Stadt laden
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Wettervorhersage'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "/Users/benjamingayda-knop/Coden/Projects/bennis_weather_app/assests/_fae9a297-346c-4943-8d19-8bb3778e82ca.jpeg"), 
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
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
                  List<dynamic> forecastData = weatherData['forecast']['list'];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Aktuelles Wetter in $_city:',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Icon(
                        WeatherLogic.getWeatherIcon(
                            currentWeatherData['weather'][0]['main']),
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
                          itemCount: forecastData.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> forecast = forecastData[index];
                            DateTime dateTime =
                                DateTime.fromMillisecondsSinceEpoch(
                                    forecast['dt'] * 1000);
                            String date =
                                DateFormat('dd.MM.yyyy').format(dateTime);
                            String time = DateFormat('HH:mm').format(dateTime);
                            String forecastMain =
                                forecast['weather'][0]['main'];
                            double forecastTemp =
                                forecast['main']['temp'].toDouble();
                            return Card(
                              child: ListTile(
                                leading: Icon(WeatherLogic.getWeatherIcon(forecastMain)),
                                title: Text(
                                  '$date $time',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text('$forecastMain, $forecastTemp°C'),
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _refreshWeatherData,
                        child: Text('Aktualisieren'),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
