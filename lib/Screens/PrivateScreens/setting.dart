import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_management_system/utils/firestorehelper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SharedPreferences prefs;
  late FirestoreHelper firestoreHelper;
  late List<String>? userData;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    prefs = await SharedPreferences.getInstance();
    firestoreHelper = await FirestoreHelper.getInstance();
    _loadUserData();
    _loadPreferences();
  }

  Future<void> _loadUserData() async {
    setState(() {
      userData = prefs.getStringList('loggedUser');
      if (userData != null) {
        _nameController.text = userData![0];
        _emailController.text = userData![1];
        _phoneController.text = userData![2];
      }
    });
  }

  Future<void> _loadPreferences() async {
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  Future<void> _updateUserData() async {
    if (userData != null) {
      userData![0] = _nameController.text;
      userData![1] = _emailController.text;
      userData![2] = _phoneController.text;
      await firestoreHelper.updateUserDetails(
          userData![1], _nameController.text, _phoneController.text);
      await prefs.setStringList('loggedUser', userData!);
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });
    await prefs.setBool('notificationsEnabled', value);
  }

  Future<void> _logout() async {
    await prefs.remove('loggedUser');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'User Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserData,
              style:
                  ElevatedButton.styleFrom(foregroundColor: Colors.deepPurple),
              child: const Text('Update Information'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              'Preferences',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
            ),
            const Divider(),
            const Text(
              'Account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
