import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:event_management_system/utils/firestorehelper.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late FirestoreHelper firestoreHelper;
  Map<DateTime, List<Event>> _events = {};
  List<Event> _selectedEvents = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  TextEditingController _eventTitleController = TextEditingController();
  TextEditingController _eventDescriptionController = TextEditingController();
  DateTime _eventDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeCalendar();
  }

  Future<void> _initializeCalendar() async {
    firestoreHelper = await FirestoreHelper.getInstance();
    await _loadEvents();
  }

  Future<void> _loadEvents() async {
    List<Event> eventsList = await firestoreHelper.getAllEvents();
    setState(() {
      _events = _groupEventsByDate(eventsList);
      _selectedEvents = _events[_selectedDay] ?? [];
    });
  }

  Map<DateTime, List<Event>> _groupEventsByDate(List<Event> events) {
    Map<DateTime, List<Event>> eventsMap = {};
    for (Event event in events) {
      DateTime date =
          DateTime(event.date.year, event.date.month, event.date.day);
      if (eventsMap[date] == null) eventsMap[date] = [];
      eventsMap[date]!.add(event);
    }
    return eventsMap;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents = _events[selectedDay] ?? [];
    });
  }

  Future<void> _addEvent() async {
    String title = _eventTitleController.text;
    String description = _eventDescriptionController.text;
    if (title.isEmpty || description.isEmpty) return;

    Event newEvent = Event('', _eventDate, title, description);
    await firestoreHelper.createEvent(
        title, description, _eventDate, int.parse(_generateUniqueId()));
    _eventTitleController.clear();
    _eventDescriptionController.clear();
    Navigator.pop(context);
    await _loadEvents();
  }

  String _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: (day) {
                return _events[day] ?? [];
              },
              onDaySelected: _onDaySelected,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Events on ${_selectedDay.toLocal()}'.split(' ')[0],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: _selectedEvents.isNotEmpty
                  ? ListView.builder(
                      itemCount: _selectedEvents.length,
                      itemBuilder: (context, index) {
                        Event event = _selectedEvents[index];
                        return ListTile(
                          title: Text(event.title),
                          subtitle: Text(event.description),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No events for this day.'),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _eventTitleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _eventDescriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addEvent,
              style: ElevatedButton.styleFrom(shadowColor: Colors.deepPurple),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
