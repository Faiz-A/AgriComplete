import 'package:flutter/material.dart';
import 'package:miniproj/gps(test).dart';
import 'gps(test).dart';
import 'login.dart';
class homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/bg.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Name in the upper middle part
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'AgriComplete',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ), // Clickable buttons in the below part of the page
          Positioned(
            bottom: 76,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              SizedBox(
              width: 200, // set the SizedBox width to 200
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  primary: Color.fromRGBO(87, 44, 36, 100),
                  elevation: 1,
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  onPrimary: Colors.white,
                  shadowColor: Colors.grey[400],
                ),
              ),
            ),
                SizedBox(
                  width: 200, // set the SizedBox width to 200
                  height:60
                ),
                SizedBox(
                  width: 200, // set the SizedBox width to 200
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LocationPage())
                      );
                    },
                    child: Text('Sign Up'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: Colors.black,
                      elevation: 2,
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
