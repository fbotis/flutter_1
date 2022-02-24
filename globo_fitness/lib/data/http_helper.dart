import 'package:globo_fitness/data/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpHelper {
// http:///?q=London&appid={apiKey}

  final String authority = 'api.openweathermap.org';
  final String path = 'data/2.5/weather';
  final String apiKey = '59ea68b2d834d5272c6c99d2da5355e0';

  Future<Weather> getWeather(String cityName) async {
    Map<String, dynamic> params = {'q': cityName, 'appId': apiKey};
    Uri uri = Uri.https(authority, path, params);

    http.Response result = await http.get(uri);
    Map<String, dynamic> data = json.decode(result.body);
    Weather weather = Weather.fromJson(data);

    return weather;
  }
}
