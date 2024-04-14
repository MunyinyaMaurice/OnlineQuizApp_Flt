import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'SignupPage.dart';
import 'admin/CreateQuizScreen.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Online Quiz App'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? accessToken; // Define accessToken in the state class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title), // Access widget properties using widget.title
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
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return const CurrentLocationScreen();
              }));
            },
            child: const Text("User current location"),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => CreateQuizScreen(accessToken: accessToken ?? ''),
          //       ),
          //     );
          //   },
          //   child: const Text("Create Quiz"),
    ElevatedButton(
    onPressed: () {
    String token = accessToken ?? ''; // Ensure token is not null
    print('Access Token: $token'); // Log the access token

    // Navigate to CreateQuizScreen only if accessToken is available
    if (token.isNotEmpty) {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => CreateQuizScreen(accessToken: token),
    ),
    );
    } else {
    // Handle case where accessToken is null or empty
    print('Access Token is null or empty. Cannot create quiz.');
    // Optionally show an error message to the user
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Access Token is null or empty. Cannot create quiz.'),
    //   ),
    // );
    }
    },
    child: const Text("Create Quiz"),
    // ),

    ),
        ],
      ),
    );
  }
}
