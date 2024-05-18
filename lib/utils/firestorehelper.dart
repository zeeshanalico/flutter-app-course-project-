import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';
import 'dart:convert';

class FirestoreHelper {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  FirestoreHelper._();

  static final FirestoreHelper _singleObj = FirestoreHelper._();
  static bool _isFirstTime = true;

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
      (dataMap["date"] as Timestamp).toDate(),
      dataMap["title"] ?? "",
      dataMap["description"] ?? "",
    );
  }

  @override
  String toString() {
    return 'Event{id: $id, date: $date, title: $title, description: $description}';
  }
}
