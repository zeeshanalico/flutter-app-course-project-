import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final List<Map<String, dynamic>> sidebarItems = [
    {'icon': Icons.home, 'title': 'Home', 'route': '/'},
    {'icon': Icons.person, 'title': 'Contact Us', 'route': '/contactus'},
    {'icon': Icons.settings, 'title': 'Settings', 'route': '/settings'},
    {'icon': Icons.logout, 'title': 'Logout', 'route': '/logout'},
    {'icon': Icons.star_rate_outlined, 'title': 'Weather', 'route': '/weather'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sidebarItems.map((item) {
          return SidebarTile(
            icon: item['icon'],
            title: item['title'],
            onTap: () {
              Navigator.pushNamed(context, item['route']);
            },
          );
        }).toList(),
        // children: [

        //   // SizedBox(height: 100),
        //   sidebarItems.map((item) {//spread operator,
        //     return SidebarTile(
        //       icon: item['icon'],
        //       title: item['title'],
        //       onTap: () {
        //         Navigator.pushNamed(context, item['route']);
        //       },
        //     );
        //   }).toList(),//convert
        // ],
      ),
    );
  }
}

class SidebarTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  SidebarTile(
      {required this.icon,
      required this.title,
      required this.onTap}); //constructor

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
