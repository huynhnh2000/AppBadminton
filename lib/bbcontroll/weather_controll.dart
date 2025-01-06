
import 'package:badminton_management_1/bbdata/aamodel/my_user.dart';
import 'package:badminton_management_1/bbdata/aamodel/my_weather.dart';
import 'package:badminton_management_1/bbdata/online/weather_api.dart';

class WeatherControll {
  //singleton
  WeatherControll._privateContructor();
  static final WeatherControll _instance = WeatherControll._privateContructor();
  factory WeatherControll(){
    return _instance;
  }
  //

  final WeatherApi weatherApi = WeatherApi();
  final currentWeather = MyCurrentWather();
  final currentUser = MyCurrentUser();

  int amountWeather = 0;


  Future<void> getCurrentWeather() async {
    String? locationKey = await weatherApi.getLocationKey();
    String url = 'https://www.accuweather.com/en/vn/ho-chi-minh-city/$locationKey/current-weather/$locationKey';
    MyWeather? fetchedWeather = await weatherApi.fetchWeatherData(url);
    currentWeather.setCurrent(fetchedWeather!);
  }

}
