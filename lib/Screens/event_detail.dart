import 'package:flutter/material.dart';
import '../utils/firestorehelper.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${event.title}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${event.date.toIso8601String().split('T')[0]}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Description: ${event.description}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventListItem extends StatelessWidget {
  final Event event;
  final bool loggedUser;

  const _EventListItem({Key? key, required this.event, this.loggedUser = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(event.title),
      subtitle: Text('Date: ${event.date.toIso8601String().split('T')[0]}'),
      trailing: const Icon(Icons.arrow_right),
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
