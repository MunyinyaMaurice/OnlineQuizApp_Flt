import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'StudentDashboard.dart';
import 'userDashboard.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Future<void> _register() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();

    final Uri uri = Uri.parse('http://192.168.56.1:23901/api/v1/auth/register');
    final Map<String, String> body = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
    final String jsonData = jsonEncode(body);

    try {
      final http.Response response = await http.post(
        uri,
        body: jsonData,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Registration successful, handle response if needed
        final Map<String, dynamic> data = json.decode(response.body);
        final String accessToken = data['access_token'];
        final String userRole = data['user_role'];

        // Check user role and navigate accordingly
        if (userRole == 'STUDENT') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentDashboard(accessToken: accessToken),
            ),
          );
        } else if (userRole == 'ADMIN') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserDashboard(accessToken: accessToken),
            ),
          );
        } else {
          // Handle unknown roles or other scenarios
          print('Unknown user role: $userRole');
        }
      } else {
        // Handle registration failure
        print('Registration failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error occurred during registration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
