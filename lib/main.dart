import 'package:flutter/material.dart';
import 'splashscreen.dart';

//Entry point of the Flutter application
void main() {
  runApp(const MyApp());
}

//The root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, //Remove the debug banner
      home: SplashScreen(), //Set Splashscreen as the first page
    );
  }
}
