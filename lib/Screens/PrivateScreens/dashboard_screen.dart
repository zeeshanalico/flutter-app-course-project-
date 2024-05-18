import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_management_system/common/drawer.dart';
import 'package:event_management_system/Screens/available_events_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<String>? userData;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferencesAndLoadUserData();
  }

  Future<void> _initSharedPreferencesAndLoadUserData() async {
    await _initSharedPreferences();
    await _loadUserData();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadUserData() async {
    setState(() {
      userData = prefs.getStringList('loggedUser');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: userData != null
            ? AvailableEvents(hideHeader: true)
            : logged_error(),
      ),
    );
  }
}

class logged_error extends StatelessWidget {
  const logged_error({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 20),
          Text(
            'No user logged in',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
