import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadEvents(context);
  }

  Future<void> _loadEvents(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> events = [
      {
        'id': '1',
        'title': 'Event 1',
        'description': 'Description for Event 1',
        'date': '2022-05-15',
      },
      {
        'id': '2',
        'title': 'Event 2',
        'description': 'Description for Event 2',
        'date': '2022-05-20',
      },
    ];

    List<String> eventsJson = events
        .map((event) => json.encode(event, toEncodable: (e) => e.toString()))
        .toList();

    await pref.setStringList('events', eventsJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Welcome to our App!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20.0),
            Image.asset(
              'home_page.jpg',
              height: 300.0,
              width: 200.0,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Browse through a wide range of events happening in your area. From concerts and festivals to conferences and workshops, find the perfect event to suit your interests',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/availableEvents');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
