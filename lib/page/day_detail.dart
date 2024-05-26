import 'package:flutter/material.dart';
import 'detail_page.dart';

class DayDetailPage extends StatelessWidget {
  final WeatherData weather;

  const DayDetailPage({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<WeatherData> filterDataForDay(List<WeatherData> data, DateTime date) {
      return data.where((item) {
        return item.date.year == date.year &&
            item.date.month == date.month &&
            item.date.day == date.day;
      }).toList();
    }

    List<WeatherData> dayData = filterDataForDay([weather], weather.date);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${weather.date.day}/${weather.date.month}/${weather.date.year} Detail'),
      ),
      body: ListView.builder(
        itemCount: dayData.length,
        itemBuilder: (context, index) {
          var hourlyData = dayData[index];
          return ListTile(
            title: Text(hourlyData.date.toString()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Min Temperature: ${hourlyData.minTemp.toStringAsFixed(2)}°C'),
                Text('Max Temperature: ${hourlyData.maxTemp.toStringAsFixed(2)}°C'),
                Text('Min Wind Speed: ${hourlyData.minWindSpeed.toStringAsFixed(2)} m/s'),
                Text('Max Wind Speed: ${hourlyData.maxWindSpeed.toStringAsFixed(2)} m/s'),
                Text('Min Humidity: ${hourlyData.minHumidity}%'),
                Text('Max Humidity: ${hourlyData.maxHumidity}%'),
              ],
            ),
          );
        },
      ),
    );
  }
}
