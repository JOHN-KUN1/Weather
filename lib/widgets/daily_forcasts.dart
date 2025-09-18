import 'package:flutter/material.dart';


class DailyForcasts extends StatelessWidget {
  const DailyForcasts({super.key, required this.temperature, required this.forecastIcon, required this.weekday});

  final String temperature;
  final String forecastIcon;
  final String weekday;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 255, 255, 255),
        boxShadow: [const BoxShadow(blurRadius: 0.0,spreadRadius: 0.2)],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              temperature,
              style: const TextStyle(
                color: Color.fromARGB(152, 255, 255, 255),
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 3,),
            Center(
              child: Image.asset(forecastIcon,height: 40,width: 40,),
            ),
            const SizedBox(height: 3,),
            Text(
              weekday,
              style:  const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }

}