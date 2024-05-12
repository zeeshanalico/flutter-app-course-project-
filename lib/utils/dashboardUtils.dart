import 'package:flutter/material.dart';

class DashboardUtils {
  static Widget buildDashboardContent(List<String> userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome, ${userData[0]}!',
                  style: const TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 10),
                Text(
                  'Email: ${userData[1]}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10),
                Text(
                  'Phone: ${userData[3]}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
