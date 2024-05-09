import 'package:flutter/material.dart';
import 'Screens/loginscreen.dart';
import 'Screens/homecreen.dart';
import 'Screens/available_events_screen.dart';
import 'Screens/registerscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => HomeScreen(),
        '/availableevents': (context) =>
            EventListWidget(url: 'https://rapidapi.com'),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(),

        // '/third': (context) => ThirdScreen(),
      },
      initialRoute: '/',
    );
  }
}
