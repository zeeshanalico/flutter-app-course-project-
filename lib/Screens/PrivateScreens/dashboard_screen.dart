import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_management_system/common/drawer.dart';
// import '../../common/sidebar.dart';

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

  Future<void> _logout() async {
    await prefs.remove('loggedUser');
    setState(() {
      userData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SafeArea(
        child: userData != null
            ? _buildDashboardContent(userData!)
            : const Center(
                child: Text('No user logged in'),
              ),
      ),
    );
  }

  Widget _buildDashboardContent(List<String> userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome, ${userData[0]}!', // Display username
                  style: const TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 10),
                Text(
                  'Email: ${userData[1]}', // Display email
                  style: const TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10),
                Text(
                  'Phone: ${userData[3]}', // Display phone number
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _logout,
            child: const Text('Logout'),
          ),
        ),
      ],
    );
  }
}
