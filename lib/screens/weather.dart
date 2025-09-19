import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
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
  List currentDate = [];
  final todaysDay = DateFormat('EEEE').format(DateTime.now());
  final todaysDayNum = DateTime.now().day;
  final todaysDayMonth = DateFormat('MMMM').format(DateTime.now());
  String userLocation = '';
  Future? loadData;

  //current weather data
  String currentTemp = '';
  String currentIcon = '';
  String currentWeatherDescription = '';
  String currentWindSpeed = '';
  String currentHumidity = '';


  // next day weather data
  String nextDayTemp = '';
  String nextDayIcon = '';
  String nextDay = '';

  // next day 2 weather data
  String nextDay2Temp = '';
  String nextDay2Icon = '';
  String nextDay2 = '';

  // next day 3 weather data
  String nextDay3Temp = '';
  String nextDay3Icon = '';
  String nextDay3 = '';

  // next day 4 weather data
  String nextDay4Temp = '';
  String nextDay4Icon = '';
  String nextDay4 = '';

  // next day 5 weather data
  String nextDay5Temp = '';
  String nextDay5Icon = '';
  String nextDay5 = '';

  // next day 6 weather data
  String nextDay6Temp = '';
  String nextDay6Icon = '';
  String nextDay6 = '';

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
      'https://api.weatherapi.com/v1/forecast.json?key=17bc2535ee464a0aa0e160633241009&q=$userCity&days=7&aqi=no&alerts=no',
    );
    var response = await http.get(url);
    var responseBody = json.decode(response.body);

    setState(() {
      var forecastDays = responseBody['forecast']['forecastday'] as List;
      print('-------------------${forecastDays.length}');
      userLocation = userCity;
      currentTemp = responseBody['current']['temp_c'].toString();
      currentWeatherDescription = responseBody['current']['condition']['text']
          .toString();
      currentIcon = responseBody['current']['condition']['icon'].toString();
      currentHumidity = responseBody['current']['humidity'].toString();
      currentWindSpeed = responseBody['current']['wind_kph'].toString();

      // data for next day 
      var nextDayDate = DateTime(int.tryParse(forecastDays[1]['date'].toString().split('-')[0])!, int.tryParse(forecastDays[1]['date'].toString().split('-')[1])!,int.tryParse(forecastDays[1]['date'].toString().split('-')[2])!);
      nextDay = DateFormat('EEE').format(nextDayDate);
      nextDayIcon = forecastDays[1]['day']['condition']['icon'].toString();
      nextDayTemp = forecastDays[1]['day']['avgtemp_c'].toString();

      // data for next day 2
      var nextDay2Date = DateTime(int.tryParse(forecastDays[2]['date'].toString().split('-')[0])!, int.tryParse(forecastDays[2]['date'].toString().split('-')[1])!,int.tryParse(forecastDays[2]['date'].toString().split('-')[2])!);
      nextDay2 = DateFormat('EEE').format(nextDay2Date);
      nextDay2Icon = forecastDays[2]['day']['condition']['icon'].toString();
      nextDay2Temp = forecastDays[2]['day']['avgtemp_c'].toString();

      // // data for next day 3
      // var nextDay3Date = DateTime(int.tryParse(forecastDays[3]['date'].toString().split('-')[0])!, int.tryParse(forecastDays[3]['date'].toString().split('-')[1])!,int.tryParse(forecastDays[3]['date'].toString().split('-')[2])!);
      // nextDay3 = DateFormat('EEE').format(nextDay3Date);
      // nextDay3Icon = forecastDays[3]['day']['condition']['icon'].toString();
      // nextDay3Temp = forecastDays[3]['day']['avgtemp_c'].toString();

      // // data for next day 4
      // var nextDay4Date = DateTime(int.tryParse(forecastDays[4]['date'].toString().split('-')[0])!, int.tryParse(forecastDays[4]['date'].toString().split('-')[1])!,int.tryParse(forecastDays[4]['date'].toString().split('-')[2])!);
      // nextDay4 = DateFormat('EEE').format(nextDay4Date);
      // nextDay4Icon = forecastDays[4]['day']['condition']['icon'].toString();
      // nextDay4Temp = forecastDays[4]['day']['avgtemp_c'].toString();

      // // data for next day 5
      // var nextDay5Date = DateTime(int.tryParse(forecastDays[5]['date'].toString().split('-')[0])!, int.tryParse(forecastDays[5]['date'].toString().split('-')[1])!,int.tryParse(forecastDays[5]['date'].toString().split('-')[2])!);
      // nextDay5 = DateFormat('EEE').format(nextDay5Date);
      // nextDay5Icon = forecastDays[5]['day']['condition']['icon'].toString();
      // nextDay5Temp = forecastDays[5]['day']['avgtemp_c'].toString();

      // // data for next day 6
      // var nextDay6Date = DateTime(int.tryParse(forecastDays[6]['date'].toString().split('-')[0])!, int.tryParse(forecastDays[6]['date'].toString().split('-')[1])!,int.tryParse(forecastDays[6]['date'].toString().split('-')[2])!);
      // nextDay6 = DateFormat('EEE').format(nextDay6Date);
      // nextDay6Icon = forecastDays[6]['day']['condition']['icon'].toString();
      // nextDay6Temp = forecastDays[6]['day']['avgtemp_c'].toString();

  
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
                  child: Image.network(
                    'http:$currentIcon',
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
                Positioned(
                  top: 50,
                  right: 40,
                  child: Text(
                    '$currentTemp°',
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
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Text(
                      textAlign: TextAlign.left,
                      currentWeatherDescription,
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
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WeatherAttributes(
                  attribute: 'Wind Speed',
                  image: 'assets/wind_speed.png',
                  value: '${currentWindSpeed}kp/h',
                ),
                WeatherAttributes(
                  attribute: 'Humidity',
                  image: 'assets/humidity.png',
                  value: currentHumidity,
                ),
                WeatherAttributes(
                  attribute: 'Max. Temp',
                  image: 'assets/temperature.png',
                  value: '$currentTemp°c',
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
                    'Next 2 Days',
                    style: TextStyle(
                      color: Color.fromARGB(255, 52, 149, 195),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DailyForcasts(
                      temperature: currentTemp,
                      forecastIcon: currentIcon,
                      weekday: DateFormat('EEE').format(DateTime.now()),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    DailyForcasts(
                      temperature: nextDayTemp,
                      forecastIcon: nextDayIcon,
                      weekday: nextDay,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    DailyForcasts(
                      temperature: nextDay2Temp,
                      forecastIcon: nextDay2Icon,
                      weekday: nextDay2,
                    ),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    // DailyForcasts(
                    //   temperature: nextDay3Temp,
                    //   forecastIcon:nextDay3Icon,
                    //   weekday: nextDay3,
                    // ),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    // DailyForcasts(
                    //   temperature: nextDay4Temp,
                    //   forecastIcon: nextDay4Icon,
                    //   weekday: nextDay4,
                    // ),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    // DailyForcasts(
                    //   temperature: nextDay5Temp,
                    //   forecastIcon: nextDay5Icon,
                    //   weekday: nextDay5,
                    // ),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    // DailyForcasts(
                    //   temperature: nextDay6Temp,
                    //   forecastIcon: nextDay6Icon,
                    //   weekday: nextDay6,
                    // ),
                  ],
                ),
              ),
            ),
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
