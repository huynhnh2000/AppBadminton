import 'package:flutter/material.dart';
import 'package:weather_animation/weather_animation.dart';

class WeatherWidget extends StatelessWidget {
  final String weatherCondition;

  const WeatherWidget({super.key, required this.weatherCondition});

  @override
  Widget build(BuildContext context) {
    final condition = weatherCondition.toLowerCase();

    if (condition.contains('rain') && condition.contains('light')) {
      return _buildLightRainyScene();
    } else if (condition.contains('rain') && condition.contains('heavy')) {
      return _buildHeavyRainyScene();
    } else if (condition.contains('thunderstorm')) {
      return _buildThunderstormScene();
    } else if (condition.contains('sunny')) {
      return _buildClearScene();
    } else if (condition.contains('cloudy')) {
      return _buildCloudyScene();
    } else {
      return _buildDefaultScene();
    }
  }

  Widget _buildLightRainyScene() {
    return const Stack(
      children: [
        WrapperScene(
          colors: [
            Color(0xff4A90E2),
            Color(0xffA3C1DA),
          ],
          children: [
            CloudWidget(),
            RainWidget(
              rainConfig: RainConfig(
                color: Color.fromARGB(255, 0, 115, 246),
                count: 15
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildHeavyRainyScene() {
    return const Stack(
      children: [
        WrapperScene(
          colors: [
            Color(0xff4A90E2),
            Color(0xffA3C1DA),
          ],
          children: [
            CloudWidget(
              cloudConfig: CloudConfig(
                color: Color.fromARGB(255, 0, 51, 92)
              ),
            ),
            RainWidget(
              rainConfig: RainConfig(
                color: Color.fromARGB(255, 0, 115, 246),
                count: 35
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildThunderstormScene() {
    return const WrapperScene(
      colors: [
        Color(0xff4A90E2),
        Color(0xffA3C1DA),
      ],
      children: [
        CloudWidget(
          cloudConfig: CloudConfig(color: Color.fromARGB(255, 0, 48, 103)),
        ),
        ThunderWidget(
          thunderConfig: ThunderConfig(
            thunderWidth: 10
          ),
        ),
      ],
    );
  }

  Widget _buildClearScene() {
    return const WrapperScene(
      colors: [
        Color(0xffFFB300),
        Color(0xffFFD54F),
      ],
      children: [
        SunWidget(),
        CloudWidget(),
      ],
    );
  }

  Widget _buildCloudyScene() {
    return const Stack(
      children: [
        WrapperScene(
          colors: [
            Color(0xff78909C), 
            Color(0xffB0BEC5), 
          ],
          children: [
            CloudWidget(),
          ],
        ),

        Positioned(
          left: 10,
          right: 00,
          top: 0,
          child: WrapperScene(
            colors: [
            ],
            children: [
              CloudWidget(),
            ],
          ),
        ),
        
      ],
    );
  }


  Widget _buildDefaultScene() {
    return const Stack(
      children: [
        WrapperScene(
          colors: [
            Color(0xffFFD54F),
            Color(0xffFFB300),
          ],
          children: [
            CloudWidget(),
            SunWidget(),
          ],
        )
      ],
    );
  }
}
