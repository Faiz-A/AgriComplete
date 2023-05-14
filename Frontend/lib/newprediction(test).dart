import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(home: flask()));
}

class flask extends StatefulWidget {
  @override
  _FlaskAppState createState() => _FlaskAppState();
}

class _FlaskAppState extends State<flask> {
  String _greeting = '';

  Future<void> _fetchGreeting() async {
    final response = await http.get(Uri.parse('http://192.168.0.104:5000/'));
    print(response.body);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    print(data);
    setState(() {
      _greeting = data['greetings'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flask App Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_greeting',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: _fetchGreeting,
              child: Text('Get Greeting'),
            ),
          ],
        ),
      ),
    );
  }
}
