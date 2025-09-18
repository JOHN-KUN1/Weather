import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/widgets/daily_forcasts.dart';
import 'package:weather_app/widgets/weather_attributes.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WeatherScreenState();
  }
}

class _WeatherScreenState extends State<WeatherScreen> {
  final todaysDay = DateFormat('EEEE').format(DateTime.now());
  final todaysDayNum = DateTime.now().day;
  final todaysDayMonth = DateFormat('MMMM').format(DateTime.now());
  String userLocation = '';
  Future? loadData;

  Future<void> getUserLocationAndWeatherData() async {
    Location location = Location();
    LocationData locationData;

    List<geo.Placemark> placemarks;

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    if (locationData.latitude == null && locationData.longitude == null) {
      return;
    }

    placemarks = await geo.placemarkFromCoordinates(
      locationData.latitude!,
      locationData.longitude!,
    );
    var city = placemarks[0].locality!;

    await getWeatherData(city);
  }

  Future<void> getWeatherData(String userCity) async {
    var url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=17bc2535ee464a0aa0e160633241009&q=$userCity&days=3&aqi=no&alerts=no',
    );
    var response = await http.get(url);
    var responseBody = json.decode(response.body);

    setState(() {
      userLocation = userCity;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData = getUserLocationAndWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userLocation,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        '$todaysDay, $todaysDayNum $todaysDayMonth',
                        style: const TextStyle(
                          color: Color.fromARGB(152, 255, 255, 255),
                          fontSize: 17,
                          // fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Card(
                  elevation: 10,
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    color: const Color.fromARGB(255, 78, 194, 248),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 40,
                  child: Image.asset(
                    'assets/weather_icon.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 40,
                  child: Text(
                    '15',
                    style: TextStyle(
                      color: const Color.fromARGB(
                        255,
                        255,
                        255,
                        255,
                      ).withValues(alpha: 0.2),
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 40,
                  child: Text(
                    'Light Cloud',
                    style: TextStyle(
                      color: const Color.fromARGB(
                        255,
                        255,
                        255,
                        255,
                      ).withValues(alpha: 0.7),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WeatherAttributes(
                  attribute: 'Wind Speed',
                  image: 'assets/wind_speed.png',
                  value: '23km/h',
                ),
                WeatherAttributes(
                  attribute: 'Humidity',
                  image: 'assets/humidity.png',
                  value: '58',
                ),
                WeatherAttributes(
                  attribute: 'Max. Temp',
                  image: 'assets/temperature.png',
                  value: '15c',
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                    ),
                  ),
                  Text(
                    'Next 7 Days',
                    style: TextStyle(
                      color: Color.fromARGB(255, 52, 149, 195),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  DailyForcasts(temperature: '12', forecastIcon: 'assets/weather_icon.png', weekday: 'Tue')
                ],
              ),
            )
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 143, 206, 235),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset(
            'assets/weather_icon.png',
            width: 50,
            height: 50,
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return content;
          }
        },
      ),
    );
  }
}
