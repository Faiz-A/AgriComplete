import 'package:flutter/material.dart';
import 'FertilizerPredict.dart';
import'Croprediction.dart';
import 'diseasedetect.dart';
import 'manualprediction.dart';

class options extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),*/
    body: Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/bg.jpg'),
    fit: BoxFit.cover,
    ),
    ),
      child: Stack(
        children: [
          // Background image
          // Image.asset(
          //   'assets/bg.jpg',
          //   fit: BoxFit.cover,
          //   height: double.infinity,
          //   width: double.infinity,
          // ),
          // Text in the upper middle part
          Positioned(
            top: 150,
            left: 10,
            right: 150,
            child: Center(
              child: Text(
                'Choose an Option:',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Buttons in the below part of the page
          Positioned(
            bottom: 290,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => finalpredict()),
                      );
                    },
                    child: Text('Crop Prediction'),
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                  height: 40,
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => manualpredict()),
                      );
                    },
                    child: Center(child: Text('Crop Prediction (Manual)',textAlign: TextAlign.center,)),
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                  height: 40,
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => diseasedet(title: "Disease Detection")),
                      );
                    },
                    child: Text('Disease Detection'),
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: Color.fromRGBO(87, 44, 36, 100),
                      elevation: 2,
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => predictf()),
                      );
                    },
                    child: Text('Fertilizer Recommendation',
                    textAlign: TextAlign.center,),
                    style: ElevatedButton.styleFrom(
                      padding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: Color.fromRGBO(87, 44, 36, 100),
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

    ),
    );
  }
}
