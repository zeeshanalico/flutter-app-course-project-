import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventListWidget extends StatefulWidget {
  final String url; // URL of the JSON data source

  const EventListWidget({super.key, required this.url});

  @override
  State<EventListWidget> createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  List<dynamic> _events = []; // List to store fetched event data

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

//   Future<void> _fetchData() async {
//     try {
//       final response = await http.get(Uri.parse(widget.url));
//       if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//         setState(() {
//           _events = data; // Update state with fetched data
//         });
//       } else {
//         // Handle error scenario (e.g., display an error message)
//         print('Error fetching data: ${response.statusCode}');
//       }
//     } catch (error) {
//       // Handle exceptions (e.g., network issues)
//       print('Error fetching data: $error');
//     }
//   }

  Future<void> _fetchData() async {
    try {
      // Simulating API response by using hardcoded data
      final data = [
        {
          "name": "Tech Conference 2024",
          "date": "2024-05-20",
          "location": "New York City"
        },
        {
          "name": "Music Festival",
          "date": "2024-06-15",
          "location": "Los Angeles"
        },
      ];

      setState(() {
        _events = data; // Update state with hardcoded data
      });
    } catch (error) {
      // Handle exceptions (if any)
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event List'),
      ),
      body: _events.isEmpty
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final eventName = _events[index]['name'];
                final eventDate = _events[index]['date'];
                final eventLocation = _events[index]['location'];

                return ListTile(
                  title: Text(eventName),
                  subtitle: Text(eventDate + " | " + eventLocation),
                );
              },
            ),
    );
  }
}
