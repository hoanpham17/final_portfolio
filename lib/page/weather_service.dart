import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';
  final String apiKey = '';
  Future<dynamic> fetchWeather(String city) async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=London&appid='));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
