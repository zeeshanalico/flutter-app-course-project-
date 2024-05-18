import 'package:event_management_system/common/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:event_management_system/utils/firestorehelper.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime date = DateTime.now();
  late FirestoreHelper firestoreHelper;

  void initState() {
    super.initState();
    _initialize();
  }

  String _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> _initialize() async {
    firestoreHelper = await FirestoreHelper.getInstance();
  }

  Future<void> _createEvent(BuildContext context) async {
    try {
      String id = _generateUniqueId();
      String title = _titleController.text;
      String description = _descriptionController.text;
      if (title == '' || description == '') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all the fields!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      // Convert the date to UTC to ensure consistency across devices
      DateTime utcDate = DateTime.utc(
        date.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );

      // Wait for the event creation to complete
      await firestoreHelper.createEvent(
          title, description, utcDate, int.parse(id));

      // Show success message if event creation is successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear text controllers after successful event creation
      _titleController.clear();
      _descriptionController.clear();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create event. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Create Event'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Text('Date: ${date.toIso8601String().split('T')[0]}'),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null && pickedDate != date) {
                      setState(() {
                        date = pickedDate;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _createEvent(context);
              },
              child: const Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }
}
