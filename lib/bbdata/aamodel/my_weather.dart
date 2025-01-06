class MyWeather{
  String? main, description, temp, humidity, nameCity;
  MyWeather({
    this.main,
    this.description,
    this.temp,
    this.humidity,
    this.nameCity
  });
}

class MyCurrentWather extends MyWeather{
  //singleton
  MyCurrentWather._privateContructor();
  static final MyCurrentWather _instance = MyCurrentWather._privateContructor();
  factory MyCurrentWather(){
    return _instance;
  }
  //

  void setCurrent(MyWeather weather){
    main = weather.main;
    description = weather.description??"";
    // if (weather.temp != null) {
    //   double tempValue = double.parse(weather.temp!.spli);
    //   temp = ((tempValue - 32) * 5 / 9).toStringAsFixed(1);
    // }
    temp = weather.temp??"";
    humidity = weather.humidity??"";
    nameCity = weather.nameCity??"";
  }
}