import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quizapp_flutter/admin/AddQuestionScreen.dart';

class CreateQuizScreen extends StatefulWidget {
  // final int quizId;
  final String accessToken;

  const CreateQuizScreen({Key? key, required this.accessToken }) : super(key: key);

  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;

  Future<void> _createQuiz(String title) async {
    final url = Uri.parse('http://192.168.56.1:23901/api/v2/auth/quiz');
    final body = jsonEncode(<String, String>{'title': title});

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.accessToken}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      print('Formatted request: $body');

      if (response.statusCode == 201) {
        // Quiz created successfully
        final quiz = jsonDecode(response.body);
        int quizId = quiz['id']; // Extract the quiz ID from the response
        // print('Quiz created successfully with ID: $quizId');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quiz created successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to AddQuestionScreen with the quiz ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddQuestionScreen(
              quizId: quizId,
              accessToken: widget.accessToken,
            ),
          ),
        );

        _titleController.clear(); // Clear text field after successful creation
      } else {
        // Handle other status codes (e.g., 4xx, 5xx)
        print('Failed to create quiz: ${response.statusCode}');
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create quiz: ${response.statusCode}'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error creating quiz: $e');
      // Show a generic error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating quiz. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Quiz Title',
                errorText: _titleController.text.isEmpty ? 'Please enter a quiz title' : null,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                String title = _titleController.text.trim();
                if (title.isNotEmpty) {
                  _createQuiz(title);
                } else {
                  // Show an error message if title is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a quiz title'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: _isLoading
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : Text('Create Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
