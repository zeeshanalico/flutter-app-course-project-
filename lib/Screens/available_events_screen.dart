import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AvailableEvents extends StatefulWidget {
  const AvailableEvents({Key? key}) : super(key: key);

  @override
  State<AvailableEvents> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<AvailableEvents> {
  List<Map<String, dynamic>> events = [];
  String _searchText = "";
  DateTime? _selectedDate;
  String? _selectedLocation;
  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    pref = await SharedPreferences.getInstance();
    var eventsString = pref.getStringList('events');
    if (eventsString != null) {
      try {
        // events =
        //     json.decode(eventsString.join(', ')).cast<Map<String, dynamic>>();
        events = [
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
          {
            'id': '3',
            'title': 'Event 3',
            'description': 'Description for Event 3',
            'date': '2022-05-20',
          },
          {
            'id': '4',
            'title': 'Event 4',
            'description': 'Description for Event 4',
            'date': '2022-05-20',
          },
          {
            'id': '5',
            'title': 'Event 5',
            'description': 'Description for Event 5',
            'date': '2022-05-20',
          },
        ];
      } catch (e) {
        print(e);
      }
    } else {
      events = [];
    }

    setState(() {});
  }

  void _filterEvents() {
    setState(() {
      events = events.where((event) => _matchesFilter(event)).toList();
    });
  }

  bool _matchesFilter(Map<String, dynamic> event) {
    bool matchesSearch = _searchText.isEmpty ||
        event['title'].toLowerCase().contains(_searchText.toLowerCase());
    bool matchesDate =
        _selectedDate == null || event['date'] == _selectedDate.toString();
    bool matchesLocation =
        _selectedLocation == null || event['location'] == _selectedLocation;
    return matchesSearch && matchesDate && matchesLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Available Events',
        ),
        automaticallyImplyLeading: false,
        actions: [
          const SizedBox(width: 20.0),
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
          ),
          const SizedBox(width: 40.0),
        ],
      ),
      body: Column(
        children: [
          // Filter section
          _buildFilterSection(),
          // List of events
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Row(
      children: [
        // Search bar
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search events',
            ),
            onChanged: (text) => setState(() => _searchText = text),
          ),
        ),
        // Date picker
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2023, 1, 1),
              lastDate: DateTime(2025, 12, 31),
            );
            if (pickedDate != null) {
              setState(() => _selectedDate = pickedDate);
            }
          },
        ),
        // Location dropdown (replace with your implementation)
        DropdownButton<String>(
          value: _selectedLocation,
          items: const [
            DropdownMenuItem(
              value: 'All locations',
              child: Text('All locations'),
            ),
            // Add more location options here
          ],
          onChanged: (value) => setState(() => _selectedLocation = value),
        ),
        // Filter button
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: _filterEvents,
        ),
      ],
    );
  }

  Widget _buildEventList() {
    if (events.isEmpty) {
      return const Center(child: Text('No events found'));
    }
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _EventListItem(event: events[index]);
      },
    );
  }
}

class _EventListItem extends StatelessWidget {
  final Map<String, dynamic> event;

  const _EventListItem({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(event['title']),
      subtitle: Text('Date: ${event['date']}'),
      trailing: const Icon(Icons.arrow_right),
      onTap: () {
        // Navigate to event details screen (implement your navigation logic)
      },
    );
  }
}
