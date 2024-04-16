import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'SignupPage.dart';
import 'admin/CreateQuizScreen.dart';
import 'admin/GoogleSignInPage.dart';
import 'current_location_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Use primarySwatch for primary color
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green[900]), // Define color scheme
      ),
      home: const MyHomePage(title: 'Online Quiz App'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  Widget _buildButton(BuildContext context, String label, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8, // Set button width
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Use the specified color for button background
          padding: const EdgeInsets.symmetric(vertical: 16), // Adjust button height
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 8), // Add space between icon and label
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), // Access title directly from the parameter
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'WELCOME TO QUIZ APP',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'YOU MAY TAKE A QUIZ NOW',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          _buildButton(
            context,
            'Login',
            Icons.login,
            Colors.white, // Use a contrasting color for better visibility
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildButton(
            context,
            'Signup',
            Icons.person_add,
            Colors.white, // Use a contrasting color for better visibility
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupPage()),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildButton(
            context,
            'User Current Location',
            Icons.location_on,
            Colors.white, // Use a contrasting color for better visibility
                () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return const CurrentLocationScreen();
              }));
            },
          ),
          const SizedBox(height: 16),
          _buildButton(
            context,
            'Google Sign-In',
            Icons.login_rounded,
            Colors.white, // Use a contrasting color for better visibility
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GoogleSignInPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
