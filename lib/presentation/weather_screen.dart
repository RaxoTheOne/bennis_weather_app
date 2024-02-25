import 'package:bennis_weather_app/data/weather_logic.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherLogic weatherLogic = WeatherLogic('Berlin', '3b19eda337d1134ce4d91224556641e7');

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
                future: weatherLogic.getWeatherData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> weatherData = snapshot.data;
                    return Column(
                      children: <Widget>[
                        Text(
                          'Aktuelles Wetter in ${weatherLogic.city}:',
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
