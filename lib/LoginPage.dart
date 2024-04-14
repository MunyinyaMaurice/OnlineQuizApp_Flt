import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'QuizListPage.dart';
import 'UserDashboard.dart'; // Import QuizListPage to navigate to it upon successful login

class Login {
  final String accessToken;
  final String refreshToken;

  Login({required this.accessToken, required this.refreshToken});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<Login>? _futureLogin;

  Future<Login> userLogin(BuildContext context, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.56.1:23901/api/v1/auth/authenticate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse response body into Login object
        final Map<String, dynamic> data = jsonDecode(response.body);
        Login login = Login.fromJson(data);

        // Navigate to QuizListPage upon successful login
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => QuizListPage(accessToken: login.accessToken),
        //   ),
        // );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserDashboard(accessToken: login.accessToken),
          ),
        );

        return login; // Return the Login object upon successful login
      } else {
        throw Exception('Failed to login user. Please check your credentials.');
      }
    } on http.ClientException catch (e) {
      throw Exception('Failed to connect to server. Please check your internet connection.');
    } catch (e) {
      throw Exception('An unexpected error occurred. Please try again later.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: (_futureLogin == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
          ),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
          ),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            try {
              // Initiate the login process
              Login login = await userLogin(context, _emailController.text, _passwordController.text);

              // If login is successful, navigation to QuizListPage is handled in userLogin method
            } catch (e) {
              // Handle login failure (display error message, etc.)
              print('Login Failed: $e');
            }
          },
          child: Text('Login'),
        ),


      ],
    );
  }

  Widget buildFutureBuilder() {
    return FutureBuilder<Login>(
      future: _futureLogin,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Login Failed: ${snapshot.error}');
        } else {
          // Handle other states as needed
          return Container();
        }
      },
    );
  }
}

void main() {
  runApp(const LoginPage());
}


//
//
// import 'dart:convert';
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// Future<Login> userLogin(String email, String password) async {
//   final response = await http.post(
//     Uri.parse('http://192.168.56.1:23901/api/v1/auth/authenticate'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'email': email,
//       'password': password,
//     }),
//   );
//
//   if (response.statusCode == 200) {
//     // Parse response body into Login object
//     final Map<String, dynamic> data = jsonDecode(response.body);
//     return Login.fromJson(data);
//   } else {
//     throw Exception('Failed to login user.');
//   }
// }
//
// class Login {
//   final String accessToken;
//   final String refreshToken;
//
//   Login({required this.accessToken, required this.refreshToken});
//
//   factory Login.fromJson(Map<String, dynamic> json) {
//     return Login(
//       accessToken: json['access_token'],
//       refreshToken: json['refresh_token'],
//     );
//   }
// }
//
// void main() {
//   runApp(const LoginPage());
// }
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
//   Future<Login>? _futureLogin;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login Page',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Login Page'),
//         ),
//         body: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(8),
//           child: (_futureLogin == null) ? buildColumn() : buildFutureBuilder(),
//         ),
//       ),
//     );
//   }
//
//   Column buildColumn() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         TextField(
//           controller: _emailController,
//           decoration: InputDecoration(
//             labelText: 'Email',
//           ),
//         ),
//         TextField(
//           controller: _passwordController,
//           decoration: InputDecoration(
//             labelText: 'Password',
//           ),
//           obscureText: true,
//         ),
//         SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () {
//             setState(() {
//               _futureLogin = userLogin(_emailController.text, _passwordController.text);
//             });
//           },
//           child: Text('Login'),
//         ),
//       ],
//     );
//   }
//
//   FutureBuilder<Login> buildFutureBuilder() {
//     return FutureBuilder<Login>(
//       future: _futureLogin,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return Column(
//             children: [
//               Text('Access Token: ${snapshot.data!.accessToken}'),
//               Text('Refresh Token: ${snapshot.data!.refreshToken}'),
//             ],
//           );
//         } else if (snapshot.hasError) {
//           return Text('${snapshot.error}');
//         }
//         return const CircularProgressIndicator();
//       },
//     );
//   }
// }


// import 'dart:convert';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
//
// Future<Login> userLogin(String email, String password) async {
//   final response = await http.post(
//     Uri.parse('http://172.19.176.1:23901/api/v1/auth/authenticate'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'email': email,
//       'password': password,
//     }),
//   );
//
//   if (response.statusCode == 200) {
//     // Login successful
//     return Login.fromJson(jsonDecode(response.body)
//     as Map<String, dynamic>);
//
//     Map<String, dynamic> data = json.decode(response.body);
//     String accessToken = data['access_token'];
//     String refreshToken = data['refresh_token'];
//     // Perform actions after successful login
//     print('Access Token: $accessToken');
//     print('Refresh Token: $refreshToken');
//   } else {
//     // Login failed
//     throw Exception('Failed to create album.');
//     // setState(() {
//     //   errorMessage = 'Login failed. Please check your credentials.';
//     }
//   }
// // }
//
// class Login {
//   // final int id;
//   final String email;
//   final String password;
//
//
//   const Login({
//     // required this.id,
//     required this.email,
//     required this.password});
//
//   factory Login.fromJson(Map<String, dynamic> json) {
//     return switch (json) {
//       {
//       'email': String email,
//       'password': String password,
//       } =>
//           Login(
//             email: email,
//             password: password,
//           ),
//       _ => throw const FormatException('Failed to login user.'),
//     };
//   }
// }
//
//
// void main() {
//   runApp( const LoginPage());
// }
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//   @override
//   // _LoginPageState createState() => _LoginPageState();
//   State<LoginPage> createState() {
//     return _LoginPageState();
//   }
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _controller = TextEditingController();
//   Future<Login>? _futureLogin;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login Page',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // home: LoginPage(),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Login Page'),
//         ),
//         body: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(8),
//           child: (_futureLogin == null) ? buildColumn() : buildFutureBuilder(),
//         ),
//       ),
//     );
//   }
//   Column buildColumn() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//               ),
//             ),
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () {
//             setState(() {
//               _futureLogin = userLogin(_controller.text, _controller.text);
//             });
//           },
//           child: Text('Login'),
//             ),
//       ],
//     );
//   }
//   FutureBuilder<Login> buildFutureBuilder() {
//     return FutureBuilder<Login>(
//       future: _futureLogin,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Login in progress
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           // Error during login process
//           return SnackBar(
//             content: Text('Error: Login failed. ${snapshot.error}'),
//           );
//         } else if (snapshot.hasData) {
//           final Login login = snapshot.data!;
//           final String accessToken = login.accessToken;
//
//           // Use the access token in your HTTP client to make authorized requests
//           // Note: You should handle HTTP requests properly outside the UI layer.
//           // Here, we're just showing a SnackBar as an example.
//           return ElevatedButton(
//             onPressed: () async {
//               final response = await http.get(
//                 Uri.parse('https://api.example.com/protected-resource'),
//                 headers: {
//                   'Authorization': 'Bearer $accessToken',
//                 },
//               );
//
//               if (response.statusCode == 200) {
//                 // Successful response
//                 final String responseBody = utf8.decode(response.bodyBytes);
//                 // Display the response body on the screen (replace with your UI logic)
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Response: $responseBody'),
//                   ),
//                 );
//               } else {
//                 // Error handling
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Error: Failed to access protected resource. Status code: ${response.statusCode}'),
//                   ),
//                 );
//               }
//             },
//             child: Text('Access Protected Resource'),
//           );
//         } else {
//           return Container(); // Placeholder widget
//         }
//       },
//     );
//   }
