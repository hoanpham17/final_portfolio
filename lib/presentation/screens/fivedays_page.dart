import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_portfolio/providers/weather_provider.dart';



class FiveDays extends StatefulWidget {
  final String city;

  const FiveDays({Key? key, required this.city}) : super(key: key);

  @override
  _FiveDaysState createState() => _FiveDaysState();
}

class _FiveDaysState extends State<FiveDays> {
  @override
  void initState() {
    super.initState();
    context.read<FiveDaysWeather>().fetchWeather(widget.city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city.toUpperCase()),
      ),
      body: FutureBuilder(
        future: 
            context.read<FiveDaysWeather>().fetchWeather(widget.city),

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
                return GestureDetector(
                  
                  child: Card(
                    elevation: 2,
                    color: Color(0xff19D2FE),
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
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Wind Speed: ${weather.minWindSpeed.toStringAsFixed(2)} - ${weather.maxWindSpeed.toStringAsFixed(2)}Km/h',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Humidity: ${weather.minHumidity} - ${weather.maxHumidity}%',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
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
