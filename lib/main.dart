import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Meet',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.grey[900],
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0))),
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.blueAccent),
            foregroundColor:
                MaterialStateColor.resolveWith((states) => Colors.white),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}