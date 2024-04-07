import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'SignupPage.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Online Quiz App'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'WELCOME TO STUDENT QUIZ PORT',
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Navigate to LoginPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            tooltip: 'Login',
            backgroundColor: Colors.blue[400],
            child: const Icon(Icons.login),
          ),
          const SizedBox(height: 16), // Adjust the spacing between buttons
          // FloatingActionButton(
          //   onPressed: () {
          //     // Navigate to SignupPage
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SignupPage()),
          //     );
          //   },
          //   tooltip: 'Signup',
          //   backgroundColor: Colors.blue[400],
          //   child: const Icon(Icons.person_add),
          // ),
        ],
      ),
    );
  }
}
