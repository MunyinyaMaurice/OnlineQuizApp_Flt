import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../userDashboard.dart';

class GoogleSignInPage extends StatefulWidget {
  @override
  _GoogleSignInPageState createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        // Obtain the authentication headers from the GoogleSignInAccount
        Map<String, String> authHeaders = await account!.authHeaders;

        // Extract the access token from the headers
        String? accessToken = authHeaders['Authorization'];

        // Navigate to UserDashboard with the obtained accessToken
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserDashboard(accessToken: accessToken ?? ''),
          ),
        );
      } else {
        // Handle sign-in cancellation
        print('Google Sign-In was cancelled by the user.');
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
      // Handle sign-in error
      if (error is PlatformException) {
        print('Google Sign-In PlatformException: ${error.message}');
        // Handle specific error cases based on the PlatformException
        // Example: show a dialog with a message based on the error
      } else {
        // Handle generic sign-in error
        // Example: show a generic error message to the user
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _handleSignIn,
          child: Text('Sign In with Google'),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// import '../UserDashboard.dart';
//
// class GoogleSignInPage extends StatefulWidget {
//   @override
//   _GoogleSignInPageState createState() => _GoogleSignInPageState();
// }
//
// class _GoogleSignInPageState extends State<GoogleSignInPage> {
//   // GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
//   final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
//   Future<void> _handleSignIn() async {
//     try {
//       // await _googleSignIn.signIn();
//       // // Once signed in, navigate to another screen or handle the user data
//       // _handleSignInSuccess(_googleSignIn.currentUser);
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => UserDashboard(accessToken: accessToken),
//       //   ),
//       // );
//       final GoogleSignInAccount? account = await _googleSignIn.signIn();
//       if (account != null) {
//         // Successful sign-in, navigate to UserDashboard
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => UserDashboard(account)),
//         );}
//     } catch (error) {
//       print('Google Sign-In Error: $error');
//       // Handle sign-in error
//     }
//   }
//
//   void _handleSignInSuccess(GoogleSignInAccount? user) {
//     if (user != null) {
//       // User signed in successfully, you can access user details here
//       print('User: ${user.displayName}');
//       print('Email: ${user.email}');
//       // Perform any further actions (e.g., navigate to another screen)
//     } else {
//       // Handle sign-in failure or user cancelled
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Sign-In Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _handleSignIn,
//           child: Text('Sign In with Google'),
//         ),
//       ),
//     );
//   }
// }
