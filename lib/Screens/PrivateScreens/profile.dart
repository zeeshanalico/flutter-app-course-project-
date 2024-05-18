import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_management_system/common/drawer.dart';
import 'package:event_management_system/utils/dashboard_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String>? userData;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferencesAndLoadUserData();
  }

  Future<void> _initSharedPreferencesAndLoadUserData() async {
    prefs = await SharedPreferences.getInstance();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      userData = prefs.getStringList('loggedUser');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: userData != null && userData!.isNotEmpty
            ? DashboardUtils.buildDashboardContent(userData!)
            : const Center(
                child: Text('No user logged in'),
              ),
      ),
    );
  }
}
