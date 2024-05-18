import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/firestorehelper.dart';

class AvailableEvents extends StatefulWidget {
  final bool hideHeader;

  const AvailableEvents({
    Key? key,
    this.hideHeader = false,
  }) : super(key: key);

  @override
  State<AvailableEvents> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<AvailableEvents> {
  List<Event> events = [];
  List<Event> filteredEvents = [];
  String _searchText = "";
  String? _selectedDate;
  late SharedPreferences pref;
  late FirestoreHelper firestoreHelper;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    pref = await SharedPreferences.getInstance();
    firestoreHelper = await FirestoreHelper.getInstance();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      List<Event> loadedEvents = await firestoreHelper.getAllEvents();
      setState(() {
        events = loadedEvents;
        filteredEvents = loadedEvents;
      });
    } catch (e) {
      print("Error loading events: $e");
    }
  }

  void _filterEvents() {
    setState(() {
      filteredEvents = events.where((event) => _matchesFilter(event)).toList();
    });
  }

  bool _matchesFilter(Event event) {
    bool matchesSearch = _searchText.isEmpty ||
        event.title.toLowerCase().contains(_searchText.toLowerCase());
    bool matchesDate = _selectedDate == null ||
        event.date.toIso8601String().startsWith(_selectedDate!);
    return matchesSearch && matchesDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !widget.hideHeader
          ? AppBar(
              title: const Text('Available Events'),
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
            )
          : null,
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
    // Extract unique dates from events for the dropdown
    Set<String> dates = events
        .map((event) => event.date.toIso8601String().substring(0, 10))
        .toSet();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Search bar
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: 16.0, right: 10), // Add padding to the bottom
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search events',
                ),
                onChanged: (text) {
                  setState(() {
                    _searchText = text;
                    _filterEvents();
                  });
                },
              ),
            ),
          ),
          // Date dropdown
          DropdownButton<String>(
            value: _selectedDate,
            hint: const Text('Select date'),
            items: dates.map((date) {
              return DropdownMenuItem<String>(
                value: date,
                child: Text(date),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDate = value;
                _filterEvents();
              });
            },
          ),
          // Clear filters button
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchText = "";
                _selectedDate = null;
                _filterEvents();
              });
            },
          ),
        ],
      ),
    );
  }

  void printEventDetails(filteredEvent) {
    print(filteredEvent);
  }

  Widget _buildEventList() {
    if (filteredEvents.isEmpty) {
      return const Center(child: Text('No events found'));
    }
    return ListView.builder(
      itemCount: filteredEvents.length,
      // itemBuilder: (context, index) {
      //   return _EventListItem(event: filteredEvents[index]);
      // },
      itemBuilder: (context, index) {
        return _EventListItem(
          event: filteredEvents[index],
          hideHeader: widget.hideHeader,
          onAddEvent: () {
            printEventDetails(filteredEvents[index]);
          },
        );
      },
    );
  }
}

class _EventListItem extends StatelessWidget {
  final Event event;
  final VoidCallback? onAddEvent; // Function to print event details
  final bool hideHeader;

  const _EventListItem(
      {Key? key, required this.event, this.onAddEvent, this.hideHeader = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(event.title),
      subtitle: Text('Date: ${event.date.toIso8601String().split('T')[0]}'),
      trailing: hideHeader
          ? IconButton(
              icon: Icon(Icons.add),
              onPressed: onAddEvent,
            )
          : Icon(Icons.arrow_right),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/eventdetail',
          arguments: event,
        );
      },
    );
  }
}
