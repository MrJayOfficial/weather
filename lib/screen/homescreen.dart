import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/model/weathermodel.dart';
import 'package:weather/service/weatherservice.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherService ws = WeatherService();
  Weather? wt;

  @override
  void initState() {
    _fetchWeatherData();
    super.initState();
  }

  String fetchDay(String date) {
    if (date.isEmpty) {
      return "";
    }

    try {
      DateTime parsedDate = DateTime.parse(date);
      final r = DateFormat("EEEE").format(parsedDate);
      return r;
    } catch (e) {
      return "";
    }
  }

  String get currentDate {
    if (wt?.localTime.isEmpty ?? true) {
      return "";
    }

    try {
      DateTime parsedDate = DateTime.parse(wt!.localTime);
      final r = DateFormat("d MMMM | EEEE").format(parsedDate);
      return r;
    } catch (e) {
      return "";
    }
  }

  String get currentTime {
    if (wt?.localTime.isEmpty ?? true) {
      return "";
    }
    try {
      DateTime parsedDate = DateTime.parse(wt!.localTime);

      final r = DateFormat("hh:mm a").format(parsedDate);
      return r;
    } catch (e) {
      return "";
    }
  }

  // Fetch the weather data and update the state
  Future<void> _fetchWeatherData() async {
    try {
      String city = await ws.getCurrentCity();
      print("This is the city $city");

      final weather = await ws.getWeather(city); // Get weather data
      if (weather != null) {
        print("This is the weather ${weather.temperature}");
        setState(() {
          wt = weather; // Update the weather data
        });
      } else {
        print("HOMESCREENERROR: Weather data is null for the city $city");
      }
    } catch (e) {
      print("HOMESCREENERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
      ),
      body: wt == null
          ? const Center(
              child: CircularProgressIndicator(), // Show a loading spinner
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 38, 67, 100),
                  Color.fromARGB(255, 25, 39, 63),
                  Color(0xFF141E30),
                  Color(0xFF141E30),
                ], begin: Alignment.topRight, end: Alignment.bottomCenter),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 1.3 * kToolbarHeight),
                child: Column(
                  children: [
                    Text(
                      "${wt!.city}, ${wt!.countryName.substring(0, 2).toUpperCase()}",
                      style: GoogleFonts.poppins(
                          color: Colors.grey.shade300.withOpacity(0.6),
                          fontSize: 20,
                          fontWeight: FontWeight.w200),
                    ),
                    Text(
                      "${wt!.temperature}\u00B0C", // Add °C here
                      style: GoogleFonts.averiaSerifLibre(
                          shadows: [
                            const BoxShadow(
                                color: Color(0xFF141E30),
                                blurRadius: 10,
                                spreadRadius: 10,
                                offset: Offset(3, 3)),
                            const BoxShadow(
                                color: Color(0xFF141E30),
                                blurRadius: 10,
                                spreadRadius: 10,
                                offset: Offset(-3, -3)),
                          ],
                          color: const Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(1),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: 250,
                      height: 250,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 38, 67, 100),
                                Color.fromARGB(255, 25, 39, 63),
                                Color(0xFF141E30),
                                Color(0xFF141E30),
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight),
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                spreadRadius: 7,
                                offset: Offset(2, 2)),
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                spreadRadius: 5,
                                offset: Offset(-2, -2)),
                          ]),
                      child: Image.network(
                        'https:${wt!.icon}',
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 2,
                                  spreadRadius: 7,
                                  offset: Offset(2, 2)),
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 2,
                                  spreadRadius: 5,
                                  offset: Offset(-2, -2)),
                            ],
                            gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 38, 67, 100),
                                  Color.fromARGB(255, 25, 39, 63),
                                  Color(0xFF141E30),
                                  Color(0xFF141E30),
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    for (int s = 1;
                                        s < wt!.forecastDays.length;
                                        s++)
                                      Expanded(
                                        child: Text(
                                          fetchDay(wt!.forecastDays[s].date),
                                          style: GoogleFonts.poppins(
                                              shadows: [
                                                const BoxShadow(
                                                    color: Color.fromARGB(
                                                        130, 140, 123, 123),
                                                    blurRadius: 5,
                                                    spreadRadius: 15,
                                                    offset: Offset(3, 3)),
                                                const BoxShadow(
                                                    color: Color.fromARGB(
                                                        151, 154, 128, 128),
                                                    blurRadius: 5,
                                                    spreadRadius: 15,
                                                    offset: Offset(-3, -3))
                                              ],
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    for (int t = 1;
                                        t < wt!.forecastDays.length;
                                        t++)
                                      Expanded(
                                        child: Text(
                                          "${wt!.forecastDays[t].avgTemp}\u00B0C", // Add °C here
                                          style: GoogleFonts.poppins(
                                              shadows: [
                                                const BoxShadow(
                                                    color: Color.fromARGB(
                                                        130, 140, 123, 123),
                                                    blurRadius: 5,
                                                    spreadRadius: 15,
                                                    offset: Offset(3, 3)),
                                                const BoxShadow(
                                                    color: Color.fromARGB(
                                                        151, 154, 128, 128),
                                                    blurRadius: 5,
                                                    spreadRadius: 15,
                                                    offset: Offset(-3, -3))
                                              ],
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 30,),
                              Row(
                                children: [
                                  for(int i = 0; i<wt!.forecastDays.length;i++)
                                  Expanded(child: Image.network("https:${wt!.forecastDays[i].icon}"))
                                ],
                              )
                            ],

                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
