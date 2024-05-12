import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterScreen> {
  late SharedPreferences pref;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    pref = await SharedPreferences.getInstance();
  }

  void register(BuildContext context) {
    String name = nameController.text;
    String email = emailController.text;
    String phone = phoneController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    if (name == '' ||
        email == '' ||
        phone == '' ||
        password == '' ||
        confirmPassword == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields!'),
        ),
      );
      return;
    }
    // Check if email is already registered
    if (pref.getStringList(email) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User with this email already exists!'),
        ),
      );
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match!'),
        ),
      );
      return;
    }

    // Save user data
    User user = User(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );

    pref.setStringList(
      user.email,
      [user.name, user.email, user.password, user.phone],
    );

    // Clear text fields
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User registered successfully!'),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Register yourself with us!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
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
            const SizedBox(height: 20.0),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                register(context);
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy User class for demonstration
class User {
  final String name;
  final String email;
  final String phone;
  final String password;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });
}
