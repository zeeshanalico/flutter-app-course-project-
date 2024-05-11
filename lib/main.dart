import 'package:flutter/material.dart';
import 'Screens/loginscreen.dart';
import 'Screens/homecreen.dart';
import 'Screens/available_events_screen.dart';
import 'Screens/registerscreen.dart';
import 'Screens/PrivateScreens//dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const HomeScreen(),
        '/availableevents': (context) => const AvailableEvents(),

        '/register': (context) => const RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        // '/third': (context) => ThirdScreen(),
      },
      initialRoute: '/',
    );
  }
}
