import 'package:flutter/material.dart';
import 'Screens/loginscreen.dart';
import 'Screens/homecreen.dart';
import 'Screens/available_events_screen.dart';
import 'Screens/registerscreen.dart';
import 'Screens/PrivateScreens//dashboard_screen.dart';
// import 'Screens//PrivateScreens/calendar.dart';
// import 'Screens/PrivateScreens/createEvent.dart';
// import 'Screens/PrivateScreens/dashboard_screen.dart';
// import 'Screens/PrivateScreens/help.dart';
// import 'Screens/PrivateScreens/myevents.dart';
import 'Screens/PrivateScreens/profile.dart';
// import 'Screens/PrivateScreens/setting.dart';

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
        '/dashboard': (context) => const DashboardScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/profile': (context) => ProfileScreen(),
      },
      initialRoute: '/',
    );
  }
}
