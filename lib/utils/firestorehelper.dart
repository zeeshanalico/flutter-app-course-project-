import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';
import 'dart:convert';

class FirestoreHelper {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  FirestoreHelper._();

  static final FirestoreHelper _singleObj = FirestoreHelper._();
  static bool _isFirstTime = true;

  String _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static Future<FirestoreHelper> getInstance() async {
    if (_isFirstTime) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      _isFirstTime = false;
    }
    return _singleObj;
  }

  Future<List<Event>> getAllEvents() async {
    List<Event> listData = [];

    try {
      var snapshot = await _firestoreInstance.collection("events").get();
      for (var doc in snapshot.docs) {
        Event event = Event.fromMap(doc.data(), doc.id);
        listData.add(event);
        print(event.toJsonString()); // Print each event as a JSON string
      }
    } catch (e) {
      print("Error getting events: $e");
    }

    return listData;
  }

  Future<void> createEvent(
      String title, String description, DateTime date, int id) async {
    try {
      await _firestoreInstance.collection("events").add({
        "id": id,
        "title": title,
        "description": description,
        "date": date.toIso8601String(),
      });
      print("Event created successfully!");
    } catch (e) {
      print("Error creating event: $e");
    }
  }

  Future<String> registerUser(
      String name, String email, String password, String phone) async {
    print(name + email + password + phone);
    try {
      var snapshot = await _firestoreInstance
          .collection("users")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return "User with this email already exists!";
      }

      await _firestoreInstance.collection("users").add({
        "id": _generateUniqueId(),
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
      });
      return "User Registered successfully!";
    } catch (e) {
      print("Error Registering User: $e");
      return "Error registering user: $e";
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      var snapshot = await _firestoreInstance
          .collection("users")
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      } else {
        return null;
      }
    } catch (e) {
      print("Error logging in user: $e");
      return null;
    }
  }

  Future<void> addEventForUser(String email, Event event) async {
    try {
      await _firestoreInstance.collection("addedEvents").add({
        "email": email,
        "addedEvent": _firestoreInstance.collection("events").doc(event.id)
      });
      print("Event added for user $email successfully!");
    } catch (e) {
      print("Error adding event for user: $e");
    }
  }

  Future<List<Event>> getUserAddedEvents(String userEmail) async {
    List<Event> userAddedEvents = [];

    try {
      var snapshot = await _firestoreInstance
          .collection("addedEvents")
          .where("email", isEqualTo: userEmail)
          .get();

      // Fetch corresponding events from the events collection
      for (var doc in snapshot.docs) {
        var eventRef = doc['addedEvent'] as DocumentReference;
        var eventDoc = await eventRef.get();
        if (eventDoc.exists) {
          var eventData = eventDoc.data() as Map<String, dynamic>;
          Event event = Event.fromMap(eventData, eventDoc.id);
          userAddedEvents.add(event);
        }
      }
    } catch (e) {
      print("Error getting user added events: $e");
    }

    return userAddedEvents;
  }

  Future<void> deleteUserAddedEvent(String userEmail, String eventId) async {
    try {
      // Get the added event document reference
      var snapshot = await _firestoreInstance
          .collection("addedEvents")
          .where("email", isEqualTo: userEmail)
          .where("addedEvent",
              isEqualTo: _firestoreInstance.collection("events").doc(eventId))
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Delete the document
        await snapshot.docs.first.reference.delete();
        print("Event deleted successfully!");
      } else {
        print("No matching event found!");
      }
    } catch (e) {
      print("Error deleting event: $e");
    }
  }
}

class Event {
  String id;
  DateTime date;
  String title;
  String description;

  Event(this.id, this.date, this.title, this.description);

  String toJsonString() {
    var dataMap = {
      "id": id,
      "date": date.toIso8601String(),
      "title": title,
      "description": description,
    };
    return jsonEncode(dataMap);
  }

  factory Event.fromMap(Map<String, dynamic> dataMap, String docId) {
    return Event(
      docId,
      DateTime.parse(dataMap["date"]),
      dataMap["title"] ?? "",
      dataMap["description"] ?? "",
    );
  }

  @override
  String toString() {
    return 'Event{id: $id, date: $date, title: $title, description: $description}';
  }
}
