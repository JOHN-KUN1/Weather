import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';


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
        color: weekday == DateFormat('EEE').format(DateTime.now()) ?  Colors.lightBlueAccent : Colors.white.withValues(alpha: 0.3),
        boxShadow: weekday == DateFormat('EEE').format(DateTime.now()) ? [const BoxShadow(color: Colors.black54,blurRadius: 1,spreadRadius: 1)] : null,
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
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 3,),
            Center(
              child: Image.network(
                    'http:$forecastIcon',
                    width: 50,
                    height: 50,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Shimmer(child: Container(
                        height: 64,
                        width: 64,
                        color: Colors.blueGrey,
                      ));
                    },
                  ),
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