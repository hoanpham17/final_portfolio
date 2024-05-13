import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherData {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final double minWindSpeed;
  final double maxWindSpeed;
  final int minHumidity;
  final int maxHumidity;

  WeatherData({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.minWindSpeed,
    required this.maxWindSpeed,
    required this.minHumidity,
    required this.maxHumidity,
  });
}

class DetailPage extends StatefulWidget {
  final String city;

  const DetailPage({Key? key, required this.city}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<List<WeatherData>> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = fetchWeather();
  }

  Future<List<WeatherData>> fetchWeather() async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=${widget.city}&appid=81b7e6fe9a73494875ec45c68254eba5'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var forecasts = <WeatherData>[];
      var groupedForecasts = <DateTime, List<double>>{};
      var groupedWindSpeed = <DateTime, List<double>>{};
      var groupedHumidity = <DateTime, List<double>>{};

      // Group forecasts by date and collect min/max temperatures, wind speeds, and humidity
      data['list'].forEach((forecast) {
        var dateTime =
            DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
        var date = DateTime(dateTime.year, dateTime.month, dateTime.day);

        if (!groupedForecasts.containsKey(date)) {
          groupedForecasts[date] = [
            (forecast['main']['temp_min'] as num).toDouble(),
            (forecast['main']['temp_max'] as num).toDouble(),
            (forecast['main']['humidity'] as num).toDouble(),
          ];
          groupedWindSpeed[date] = [
            (forecast['wind']['speed'] as num).toDouble(),
            (forecast['wind']['speed'] as num).toDouble(),
          ];
          groupedHumidity[date] = [
            (forecast['main']['humidity'] as num).toDouble(),
            (forecast['main']['humidity'] as num).toDouble(),
          ];
        } else {
          groupedForecasts[date]![0] = groupedForecasts[date]![0] <
                  (forecast['main']['temp_min'] as num).toDouble()
              ? groupedForecasts[date]![0]
              : (forecast['main']['temp_min'] as num).toDouble();
          groupedForecasts[date]![1] = groupedForecasts[date]![1] >
                  (forecast['main']['temp_max'] as num).toDouble()
              ? groupedForecasts[date]![1]
              : (forecast['main']['temp_max'] as num).toDouble();
          groupedWindSpeed[date]![0] = groupedWindSpeed[date]![0] <
                  (forecast['wind']['speed'] as num).toDouble()
              ? groupedWindSpeed[date]![0]
              : (forecast['wind']['speed'] as num).toDouble();
          groupedWindSpeed[date]![1] = groupedWindSpeed[date]![1] >
                  (forecast['wind']['speed'] as num).toDouble()
              ? groupedWindSpeed[date]![1]
              : (forecast['wind']['speed'] as num).toDouble();
          groupedHumidity[date]![0] = groupedHumidity[date]![0] <
                  (forecast['main']['humidity'] as num).toDouble()
              ? groupedHumidity[date]![0]
              : (forecast['main']['humidity'] as num).toDouble();
          groupedHumidity[date]![1] = groupedHumidity[date]![1] >
                  (forecast['main']['humidity'] as num).toDouble()
              ? groupedHumidity[date]![1]
              : (forecast['main']['humidity'] as num).toDouble();
        }
      });

      // Create WeatherData objects from grouped data
      groupedForecasts.forEach((date, values) {
        forecasts.add(WeatherData(
          date: date,
          minTemp: values[0] - 273.15,
          maxTemp: values[1] - 273.15,
          minHumidity: groupedHumidity[date]![0].toInt(),
          maxHumidity: groupedHumidity[date]![1].toInt(),
          minWindSpeed: groupedWindSpeed[date]![0],
          maxWindSpeed: groupedWindSpeed[date]![1],
        ));
      });

      return forecasts;
    } else {
      throw Exception('Failed to load weather');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.city.toUpperCase()), // Convert city name to uppercase
      ),
      body: FutureBuilder<List<WeatherData>>(
        future: futureWeather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var weather = snapshot.data![index];
                return Card(
                  elevation: 2,
                  color: Color(
                      0xff19D2FE), // Use primary color as card background color
                  child: ListTile(
                    title: Text(
                      '${weather.date.day}/${weather.date.month}/${weather.date.year}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Temp: ${weather.minTemp.toStringAsFixed(2)}°C - ${weather.maxTemp.toStringAsFixed(2)}°C',
                          style: TextStyle(
                              color:
                                  Colors.white), // Change text color to white
                        ),
                        Text(
                          'Wind Speed: ${weather.minWindSpeed.toStringAsFixed(2)} - ${weather.maxWindSpeed.toStringAsFixed(2)}',
                          style: TextStyle(
                              color:
                                  Colors.white), // Change text color to white
                        ),
                        Text(
                          'Humidity: ${weather.minHumidity} - ${weather.maxHumidity}',
                          style: TextStyle(
                              color:
                                  Colors.white), // Change text color to white
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
