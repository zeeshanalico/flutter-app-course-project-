import 'package:event_management_system/common/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:event_management_system/utils/firestorehelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  List<Event> userEvents = [];
  late FirestoreHelper firestoreHelper;
  String? loggedUserEmail;
  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    pref = await SharedPreferences.getInstance();
    firestoreHelper = await FirestoreHelper.getInstance();
    await _loadLoggedUserEmail();
    await _loadUserEvents();
  }

  Future<void> _loadLoggedUserEmail() async {
    setState(() {
      loggedUserEmail = pref.getStringList('loggedUser')?[1];
    });
  }

  Future<void> _loadUserEvents() async {
    if (loggedUserEmail != null) {
      try {
        List<Event> events =
            await firestoreHelper.getUserAddedEvents(loggedUserEmail!);
        setState(() {
          userEvents = events;
        });
      } catch (e) {
        print("Error loading user events: $e");
      }
    }
  }

  Future<void> _deleteEvent(String eventId) async {
    if (loggedUserEmail != null) {
      try {
        await firestoreHelper.deleteUserAddedEvent(loggedUserEmail!, eventId);
        await _loadUserEvents(); // Refresh the list after deletion
      } catch (e) {
        print("Error deleting event: $e");
      }
    }
  }

  void _confirmDeleteEvent(BuildContext context, String eventId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Event"),
          content: const Text("Are you sure you want to delete this event?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteEvent(eventId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('My Events'),
        // automaticallyImplyLeading: false,
      ),
      body: userEvents.isNotEmpty
          ? ListView.builder(
              itemCount: userEvents.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(userEvents[index].id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (direction) {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Event"),
                          content: const Text(
                              "Are you sure you want to delete this event?"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: const Text("Delete"),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    _deleteEvent(userEvents[index].id);
                  },
                  child: ListTile(
                    title: Text(userEvents[index].title),
                    subtitle: Text(
                        'Date: ${userEvents[index].date.toIso8601String().split('T')[0]}'),
                    onTap: () {
                      // Navigate to event detail screen
                      Navigator.pushNamed(
                        context,
                        '/eventdetail',
                        arguments: userEvents[index],
                      );
                    },
                  ),
                );
              },
            )
          : const Center(
              child: Text('No events added yet.'),
            ),
    );
  }
}
