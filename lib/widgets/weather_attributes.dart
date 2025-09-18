import 'package:flutter/material.dart';

class WeatherAttributes extends StatelessWidget {
  const WeatherAttributes({super.key, required this.attribute, required this.image, required this.value});

  final String attribute;
  final String image;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          attribute,
          style: const TextStyle(
            color: Color.fromARGB(152, 255, 255, 255),
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(height: 3,),
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: const Color.fromARGB(92, 255, 255, 255),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Center(
            child: Image.asset(image,height: 40,width: 40,),
          ),
        ),
        const SizedBox(height: 3,),
        Text(
          value,
          style:  const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }

}