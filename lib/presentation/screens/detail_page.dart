import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_portfolio/models/weather.dart';
import 'package:final_portfolio/presentation/widgets/detail_weather.dart';
import 'package:final_portfolio/presentation/widgets/location.dart';
import 'package:final_portfolio/presentation/widgets/temperature.dart';
import 'package:final_portfolio/presentation/widgets/weather_icon.dart';
import 'package:final_portfolio/providers/weather_provider.dart';

class DetailPage extends StatefulWidget {
  final String city;

  const DetailPage({Key? key, required this.city}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<CurrentWeather>().getWeatherCurrent(widget.city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Currrent Weather'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff1D6CF3),
                  Color(0xff19D2FE),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: FutureBuilder(
              future:
                  context.read<CurrentWeather>().getWeatherCurrent(widget.city),
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData) {
                  return Container(
                    child: const Text('no data'),
                  );
                }

                WeatherData data = snapshot.data as WeatherData;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Location(
                      nameLocation: data.name,
                    ),
                    WeatherIcon(
                      nameIcon: data.weather[0].main,
                    ),
                    Temperature(
                      temp: data.main.temp,
                      feels_like: data.main.feels_like,
                    ),
                    Spacer(),
                    DetailWeather(
                      humidity: data.main.humidity,
                      speedWind: data.wind.speed,
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
