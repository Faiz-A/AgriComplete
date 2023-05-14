import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'options.dart';

const String API_URL = 'http://192.168.29.172:5000/predict';
const String API_KEY = '5ea17240dec343ffa5b75800232204';

class finalpredict extends StatefulWidget {
  const finalpredict({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<finalpredict> {
  final _formKey = GlobalKey<FormState>();
  double _temperature = 0.0;
  int _humidity = 0;
  //double _rainfall = 0.0;
  bool _isLoading = true;
  double? _nitrogen;
  double? _phosphorus;
  double? _potassium;
  //double? _temperature;
  //int? _humidity;
  double? _ph;
  double? _rainfall;
  //bool _isLoading = true;
  String _crop = '';

  void _getCurrentWeather() async {
    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Make API request
      String apiUrl =
          'http://api.weatherapi.com/v1/current.json?key=$API_KEY&q=${position
          .latitude},${position.longitude}';
      http.Response response = await http.get(Uri.parse(apiUrl));
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Parse API response
      setState(() {
        //_location = jsonResponse['location']['name'];
        _temperature = jsonResponse['current']['temp_c'];
        _humidity = jsonResponse['current']['humidity'];
        //_rainfall = jsonResponse['current']['precip_mm'];
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  } //WEATHER API

  @override
  void initState() {
    super.initState();
    _getCurrentWeather();
  } //INITIALIZE WEATHER API

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      final response = await http.post(Uri.parse(API_URL),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'Nitrogen': _nitrogen,
            'Phosphorus': _phosphorus,
            'Potassium': _potassium,
            'Temperature': _temperature,
            'Humidity': _humidity,
            'pH': _ph,
            'Rainfall': _rainfall,
          }));
      final result = jsonDecode(response.body)['result'] as String;
      setState(() {
        _crop = result;
      });
    }
  } //FLASK API

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.only(left: 0, top: 46),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    child: BackButton(
                      color: Colors.black,
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => options()),
                      ),
                    ),
                  ),
                 /* BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0),
                    ),
                  ),*/
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      'Enter the values for each parameter:',
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    TextFormField(
                                      decoration:
                                      const InputDecoration(
                                          labelText: 'Nitrogen (10-90)'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return 'Please enter a value';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _nitrogen = double.tryParse(value ?? '');
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      decoration:
                                      const InputDecoration(
                                          labelText: 'Phosphorus (10-90)'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return 'Please enter a value';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _phosphorus =
                                            double.tryParse(value ?? '');
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      decoration:
                                      const InputDecoration(
                                          labelText: 'Potassium (10-90)'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return 'Please enter a value';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _potassium = double.tryParse(value ?? '');
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    Text('Temperature: ${_temperature?.toStringAsFixed(2) ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    SizedBox(height: 10),
                                    Text('Humidity: ${_humidity?.toStringAsFixed(
                                        2) ?? 'N/A'}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'pH (1-14)'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return 'Please enter a value';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _ph = double.tryParse(value ?? '');
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Rainfall in mm'),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value?.isEmpty == true) {
                                          return 'Please enter a value';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        _rainfall = double.tryParse(value ?? '');
                                      },
                                    ),
                                    // Text('Rainfall: ${_rainfall?.toStringAsFixed(
                                    //     2) ?? 'N/A'}'),
                                    SizedBox(height: 10),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await _submitForm();
                                          setState(() {});
                                        },
                                        child: Text('Predict'),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: Text(
                                        'Predicted Crop: $_crop',
                                            style: TextStyle(fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ]),
                            ))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
