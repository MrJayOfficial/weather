import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:weather/model/weathermodel.dart';

class WeatherService {
  final String apiKey = '8ce54de1f17c479a9a3164643241311'; // Replace with your WeatherAPI key
  final String baseUrl = 'https://api.weatherapi.com/v1/forecast.json';

  // Function to get the user's current location
  Future<String> getCurrentCity() async {
    LocationPermission permission;

    // Check if location permission is granted
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error('Location permissions are denied');
      }
    }

    // Get the user's current position
    Position currentPosition = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);

    // Get the first placemark and return the city
    if (placemarks.isNotEmpty) {
      return placemarks[0].locality ?? 'Unknown City';
    } else {
      return 'City not found';
    }
  }

  // Function to get the weather data based on the user's location
  Future<Weather?> getWeather(String city) async {
    try {
      print("City name: $city");

      // Construct the URL for fetching the forecast
      final response = await http.get(
        Uri.parse('$baseUrl?key=$apiKey&q=$city&days=5'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        return Weather.fromJson(data);
      } else {
        print('Error: ${response.statusCode}');
        throw Exception("Failed to retrieve weather data");
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
