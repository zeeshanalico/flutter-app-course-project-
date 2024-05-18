import 'package:event_management_system/common/Drawer.dart';
import 'package:flutter/material.dart';

class HelpAndSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Help and Support'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Help and Support',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'FAQs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: Text('How to create an account?'),
              subtitle: Text(
                  'To create an account, go to the Sign Up page and fill in your details.'),
            ),
            ListTile(
              title: Text('How to reset my password?'),
              subtitle: Text(
                  'Go to the Forgot Password page and follow the instructions.'),
            ),
            ListTile(
              title: Text('How to contact support?'),
              subtitle: Text(
                  'You can contact support via the email or phone number provided below.'),
            ),
            SizedBox(height: 20),
            Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: Icon(Icons.email, color: Colors.deepPurple),
              title: Text('Email'),
              subtitle: Text('support@eventmanagement.com'),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.deepPurple),
              title: Text('Phone'),
              subtitle: Text('+92 321 9362267'),
            ),
            ListTile(
              leading: Icon(Icons.language, color: Colors.deepPurple),
              title: Text('Website'),
              subtitle: Text('www.eventmanagement.com'),
            ),
            SizedBox(height: 20),
            Text(
              'Support Hours',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: Text('Monday - Friday'),
              subtitle: Text('9:00 AM - 6:00 PM'),
            ),
            ListTile(
              title: Text('Saturday'),
              subtitle: Text('10:00 AM - 4:00 PM'),
            ),
            ListTile(
              title: Text('Sunday'),
              subtitle: Text('Closed'),
            ),
          ],
        ),
      ),
    );
  }
}
