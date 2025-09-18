import 'package:flutter/material.dart';
import 'package:weather_app/screens/weather.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 143, 206, 235),
              Color.fromARGB(255, 101, 188, 228),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/get_started_pic2.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const WeatherScreen(),));
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(210, 40),
                  backgroundColor: const Color.fromARGB(255, 136, 199, 228),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
