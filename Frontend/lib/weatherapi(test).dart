import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String API_KEY = '5ea17240dec343ffa5b75800232204';

class weather extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<weather> {
  String _location = '';
  double _temperature = 0.0;
  int _humidity = 0;
  double _rainfall = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentWeather();
  }

  void _getCurrentWeather() async {
    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Make API request
      String apiUrl =
          'http://api.weatherapi.com/v1/current.json?key=$API_KEY&q=${position.latitude},${position.longitude}';
      http.Response response = await http.get(Uri.parse(apiUrl));
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Parse API response
      setState(() {
        _location = jsonResponse['location']['name'];
        _temperature = jsonResponse['current']['temp_c'];
        _humidity = jsonResponse['current']['humidity'];
        _rainfall = jsonResponse['current']['precip_mm'];
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Current Weather'),
        ),
        body: Center(
          child: _isLoading ? CircularProgressIndicator() : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_location',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 16),
              Text(
                'Temperature: $_temperature°C',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Humidity: $_humidity%',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Rainfall: $_rainfall mm',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
