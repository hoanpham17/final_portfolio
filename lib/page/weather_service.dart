import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<dynamic> fetchWeather(String city) async {
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=London&appid=81b7e6fe9a73494875ec45c68254eba5'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
