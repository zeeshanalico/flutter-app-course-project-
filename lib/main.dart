import 'package:flutter/material.dart';
import 'Screens/loginscreen.dart';
import 'Screens/homecreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Management System',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        // '/third': (context) => ThirdScreen(),
      },
    );
  }
}
