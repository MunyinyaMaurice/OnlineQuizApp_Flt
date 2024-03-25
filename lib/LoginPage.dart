
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // final Uri uri = Uri.parse('http://127.0.0.1:23901/api/v1/auth/authenticate');
    final Uri uri = Uri.parse('http://192.168.137.1:23901/api/v1/auth/authenticate');
    final Map<String, String> body = {
      'email': email,
      'password': password,
    };
    final String jsonData = jsonEncode(body); // Encode body data as JSON

    try {
      final http.Response response = await http.post(
        uri,
        body: jsonData,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String accessToken = data['access_token']; // Assuming access_token is the key in response
        print("Loged in successful with access token: $accessToken");

        // Navigate to the next screen or perform any actions after successful login with the access token
      } else {
        final String errorMessage = response.body.toString(); // Capture the error message from response body
        print('Login failed. Status code: ${response.statusCode}');
        print('Error message: $errorMessage');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text(errorMessage), // Display the captured error message
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle network errors
      print('Error occurred during login: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to connect to the server. Please check your internet connection and try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}


//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   Future<void> _login() async {
//     // 1. Check for empty fields
//     final String email = _emailController.text.trim();
//     final String password = _passwordController.text.trim();
//     if (email.isEmpty || password.isEmpty) {
//       // Show a dialog or display an error message
//       print('Email or password can not be empty');
//       // return
//     }
//
//     final Uri uri = Uri.parse('http://127.0.0.1:23901/api/v1/auth/authenticate');
//     final Map<String, String> body = {
//       'email': email,
//       'password': password,
//     };
//
//     try {
//       final http.Response response = await http.post(uri, body: jsonEncode(body)); // Encode data as JSON
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         final String accessToken = data['access_token'];
//         final String refreshToken = data['refresh_token'];
//
//         // Navigate to the next screen or perform any actions after successful login
//       } else {
//         // Handle error responses (check response.body for error messages)
//         print('Login failed. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle network errors
//       print('Error occurred during login: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _login,
//               child: const Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
