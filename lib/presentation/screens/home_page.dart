import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_portfolio/bloc/theme_bloc.dart';
import 'detail_page.dart';
import 'fivedays_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          Switch(
              value: context.read<ThemeBloc>().state == ThemeMode.dark,
              onChanged: (value) {
                context.read<ThemeBloc>().add(ThemeChange(value));
              })
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff1D6CF3),
              Color(0xff19D2FE),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/weathers/patchyrainpossible.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 30),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _toDetailPage(context, _cityController.text);
              },
              child: Text(
                'Current Weather',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Colors.orange), 
                padding: MaterialStateProperty.all(
                    EdgeInsets.all(15)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _toFiveDays(context, _cityController.text);
              },
              child: Text(
                'Weather for 5 days',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 188, 131, 131),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Colors.yellow), 
                padding: MaterialStateProperty.all(
                    EdgeInsets.all(15)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _toDetailPage(BuildContext context, String city) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailPage(city: city),
      ),
    );
  }

  void _toFiveDays(BuildContext context, String city) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FiveDays(city: city),
      ),
    );
  }
}
