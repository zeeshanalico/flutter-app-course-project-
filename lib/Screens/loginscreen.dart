import 'package:event_management_system/Screens/PrivateScreens/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _login(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();

    String email = emailController.text;
    String password = passwordController.text;
    List<String> userData = pref.getStringList(email) ?? [];

    if (userData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User with this email does not exist.'),
        ),
      );
      return;
    }

    // Implement secure password comparison (e.g., using a hash)
    // Replace this with your actual password hashing logic
    if (password == userData[2]) {
      pref.setStringList('loggedUser', userData);
      if (mounted) {
        // Check if the widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed in successfully!'),
          ),
        );
      }
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => DashboardScreen()),
      // );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const DashboardScreen()),
      // );
      Navigator.pushNamed(context, '/dashboard');
    } else {
      if (mounted) {
        // Check if the widget is still mounted
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter correct password!'),
          ),
        );
      }
      return;
    }

    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Login'),
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'Login yourself!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // const SizedBox(height: 20.0),
            Image.asset(
              'userpic.png',
              // height: 300.0,
              width: 200.0,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email address',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
