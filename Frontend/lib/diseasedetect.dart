import 'dart:convert';
import 'dart:io';
import 'options.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class diseasedet extends StatefulWidget {
  diseasedet({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<diseasedet> {
  File? selectedImage;
  var resJson;

  Future<void> onUploadImage() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://192.168.29.172:9000/upload"),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        selectedImage!.path,
        filename: selectedImage!
            .path
            .split('/')
            .last,
      ),
    );
    request.headers.addAll(headers);
    print("request: " + request.toString());
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);
    setState(() {
      resJson = jsonDecode(response.body);
    });
  }

  Future<void> getImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image != null ? File(image.path) : null;
    });
  }

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              selectedImage == null
                  ? Expanded(
                child: Container(
                  child: Text(
                    '',
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
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
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.file(selectedImage!),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: onUploadImage,
                      child: Center(child: Text('Upload')),
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
                 /* ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.green[300]),
                    onPressed: onUploadImage,
                    child: Text(
                      "Upload",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      resJson != null ? resJson['message'].toString() : '',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => options(),
                      ),
                    ),
                    child: Text(
                      "Back",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

}