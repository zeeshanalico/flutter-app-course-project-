import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuItem {
  final IconData icon;
  final String title;
  final String routeName;

  MenuItem({
    required this.icon,
    required this.title,
    required this.routeName,
  });
}

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedUser');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text(
        'Logout',
        style: TextStyle(color: Colors.black),
      ),
      onTap: () => _logout(context),
    );
  }
}

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final List<MenuItem> items = [
    MenuItem(
        icon: Icons.dashboard, title: "Dashboard", routeName: "/dashboard"),
    MenuItem(icon: Icons.person, title: "Profile", routeName: "/profile"),
    MenuItem(icon: Icons.event, title: "My Events", routeName: "/myevents"),
    MenuItem(
        icon: Icons.add_box, title: "Create Event", routeName: "/createevent"),
    MenuItem(
        icon: Icons.calendar_today, title: "Calendar", routeName: "/calendar"),
    MenuItem(icon: Icons.settings, title: "Settings", routeName: "/setting"),
    MenuItem(icon: Icons.help, title: "Help & Support", routeName: "/help"),
    MenuItem(
        icon: Icons.logout, title: "Logout", routeName: "/availableevents"),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: 200,
        child: ListView(
          children: [
            Container(
              height: 100,
              child: const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Text(
                  'Manage your Events',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            for (var item in items)
              if (item.title == 'Logout')
                LogoutWidget()
              else
                ListTile(
                  leading: Icon(item.icon),
                  title: Text(
                    item.title,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, item.routeName);
                  },
                ),
          ],
        ),
      ),
    );
  }
}
