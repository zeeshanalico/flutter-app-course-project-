import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_management_system/common/drawer.dart';
// import '../../utils/dashboardUtils.dart';
import 'package:event_management_system/utils/dashboardUtils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<ProfileScreen> {
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
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: userData != null
            ? DashboardUtils.buildDashboardContent(userData!)
            : const Center(
                child: Text('No user logged in'),
              ),
      ),
    );
  }
}
