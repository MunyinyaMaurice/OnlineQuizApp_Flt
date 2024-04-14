import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'QuizListPage.dart';
import 'package:quizapp_flutter/admin/CreateQuizScreen.dart';

class UserDashboard extends StatelessWidget {
  final String accessToken;


  const UserDashboard({Key? key, required this.accessToken}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final url = Uri.parse('http://192.168.56.1:23901/api/v1/auth/logout');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        // Logout successful, navigate to login page
        Navigator.pushReplacementNamed(context, '/login'); // Replace with your login route
      } else {
        // Handle logout failure
        print('Failed to logout. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle logout error
      print('Error occurred during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'User Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Quiz List'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizListPage(accessToken: accessToken),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Create Quiz'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateQuizScreen(accessToken: accessToken),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _logout(context); // Call logout function
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to your dashboard!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
