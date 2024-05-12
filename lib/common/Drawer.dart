import 'package:flutter/material.dart';

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

class MyDrawer extends StatelessWidget {
  MyDrawer({Key? key}) : super(key: key);

  final List<MenuItem> items = [
    MenuItem(
        icon: Icons.dashboard, title: "Dashboard", routeName: "/dashboard"),
    MenuItem(icon: Icons.event, title: "My Events", routeName: "/myevents"),
    MenuItem(
        icon: Icons.add_box, title: "Create Event", routeName: "/createevent"),
    MenuItem(
        icon: Icons.calendar_today, title: "Calendar", routeName: "/calendar"),
    MenuItem(icon: Icons.person, title: "Profile", routeName: "/profile"),
    MenuItem(icon: Icons.settings, title: "Settings", routeName: "/setting"),
    MenuItem(icon: Icons.help, title: "Help & Support", routeName: "/help"),
    MenuItem(icon: Icons.logout, title: "Logout", routeName: "/logout"),
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
                  'Manage Your Events',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            for (var item in items)
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
