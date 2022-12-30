import 'package:flutter/material.dart';
import 'package:flutter_zoom_clone/services/meet_kit.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  final MeetingKit meetingKit = MeetingKit();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: meetingKit),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
