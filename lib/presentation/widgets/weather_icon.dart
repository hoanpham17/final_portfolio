import 'package:flutter/material.dart';
import 'package:final_portfolio/providers/weather_provider.dart';


class WeatherIcon extends StatelessWidget {
  const WeatherIcon({super.key, required this.nameIcon});

  final String nameIcon;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width / 2,
      padding: const EdgeInsets.all(5.0),
      child: Image.asset(
        AssetCustom.getLinkImg(nameIcon),
        fit: BoxFit.cover,
      ),
    );
  }
}
