import 'package:flutter/material.dart';
import 'package:final_portfolio/models/weather.dart';
import 'package:http/http.dart' as http;
import 'package:final_portfolio/apps/utils/const.dart';
import 'dart:convert';

class apiCurrentWeather {
  static Future<WeatherData> callApiGetWeather(String city) async {
    try {
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=${MyKey.api_token}'));
      final data = json.decode(res.body);
      WeatherData result = WeatherData.fromMap(data);
      return result;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}

class CurrentWeather extends ChangeNotifier {
  Future<WeatherData> getWeatherCurrent(city) async {
    WeatherData result = await apiCurrentWeather.callApiGetWeather(city);
    return result;
  }
}



class FiveDaysWeather extends ChangeNotifier {

  Future<List<WeatherDataFiveDays>> fetchWeather(city) async {
    final result = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&appid=${MyKey.api_token}'));
  

    if (result.statusCode == 200) {
      var data = jsonDecode(result.body);
      var forecasts = <WeatherDataFiveDays>[];
      var groupedTemp = <DateTime, List<double>>{};
      var groupedWindSpeed = <DateTime, List<double>>{};
      var groupedHumidity = <DateTime, List<double>>{};

      // Group forecasts by date and collect min/max temperatures, wind speeds, and humidity
      data['list'].forEach((forecast) {
        var dateTime =
            DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
        var date = DateTime(dateTime.year, dateTime.month, dateTime.day);

        if (!groupedTemp.containsKey(date)) {
          groupedTemp[date] = [
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
          groupedTemp[date]![0] = groupedTemp[date]![0] <
                  (forecast['main']['temp_min'] as num).toDouble()
              ? groupedTemp[date]![0]
              : (forecast['main']['temp_min'] as num).toDouble();
          groupedTemp[date]![1] = groupedTemp[date]![1] >
                  (forecast['main']['temp_max'] as num).toDouble()
              ? groupedTemp[date]![1]
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
      groupedTemp.forEach((date, values) {
        forecasts.add(WeatherDataFiveDays(
          date: date,
          minTemp: values[0],
          maxTemp: values[1],
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
}
