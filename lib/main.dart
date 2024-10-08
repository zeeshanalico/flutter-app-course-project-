import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/loginscreen.dart';
import 'Screens/homecreen.dart';
import 'Screens/available_events_screen.dart';
import 'Screens/registerscreen.dart';
import 'Screens/event_detail.dart';
import 'Screens/PrivateScreens//dashboard_screen.dart';
import 'Screens/PrivateScreens/profile.dart';
import './utils/firestorehelper.dart';
import 'Screens/PrivateScreens/createEvent.dart';
import 'Screens/PrivateScreens/myevents.dart';
import 'Screens//PrivateScreens/calendar.dart';
import 'Screens/PrivateScreens/help.dart';
import 'Screens/PrivateScreens/setting.dart';

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
        '/availableevents': (context) => const AvailableEvents(),
        '/eventdetail': (context) => EventDetailScreen(
              event: ModalRoute.of(context)!.settings.arguments as Event,
            ),
        '/dashboard': (context) => const DashboardScreen(),
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/profile': (context) => ProfileScreen(),
        '/createevent': (context) => CreateEvent(),
        '/myevents': (context) => MyEvents(),
        '/help': (context) => HelpAndSupport(),
        '/calendar': (context) => CalendarScreen(),
        '/setting': (context) => SettingsScreen(),
      },
      initialRoute: '/',
    );
  }
}



// create Event
// Add event
