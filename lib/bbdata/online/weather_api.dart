
import 'dart:developer';

import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_weather.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class WeatherApi{

  // final String geopositionUrl = "${dotenv.env["ACCUWEATHER_GEOPOSITION_URL"]}";
  // final String hour1Url = "${dotenv.env["ACCUWEATHER_1HOUR_URL"]}";
  // final String apiKey = "${dotenv.env["ACCUWEATHER_KEY"]}";

  final currentUser = MyCurrentUser();

  Future<String?> getLocationKey() async{
    String url = 'https://www.accuweather.com/en/search-locations?query=${currentUser.latitude},${currentUser.longitude}';
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      var locationLink = document.querySelector('a[href*="/weather-forecast/"]');

      if (locationLink != null) {
        var href = locationLink.attributes['href'];
        String? locationKey = href?.split('/').last;
        return locationKey;
      }
    } else {
      log('Failed to load page, status: ${response.statusCode}');
      return null;
    }
    return null;
  }

  Future<MyWeather?> fetchWeatherData(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        var document = parser.parse(response.body);

        String? main = document
            .getElementsByClassName('phrase')[0] 
            .text;

        String? description = main;

        String? temp = document
            .getElementsByClassName('display-temp')[0] 
            .text.replaceAll(" ", "");

        String? humidity = document
            .getElementsByClassName('detail-item spaced-content')[1] 
            .text.replaceAll(" ", "");

        String? nameCity = document
            .getElementsByClassName('recent-location__name')[0] 
            .text;

        return MyWeather(
          main: main,
          description: description,
          temp: temp,
          humidity: humidity,
          nameCity: nameCity,
        );
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      log('Error fetching weather data: $e');
      return null; 
    }
  }
}