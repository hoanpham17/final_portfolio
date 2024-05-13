import 'package:flutter/material.dart';
import 'detail_page.dart'; // Ensure this import points to where DetailPage is defined.

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              width: 100, // Fixed width for the image
            ),
            SizedBox(height: 30), // Space between the image and the text field
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20), // Space between text field and button
            ElevatedButton(
              onPressed: () {
                _navigateToDetailPage(context, _cityController.text);
              },
              child: const Text('Search Weather'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetailPage(BuildContext context, String city) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailPage(city: city),
      ),
    );
  }
}
