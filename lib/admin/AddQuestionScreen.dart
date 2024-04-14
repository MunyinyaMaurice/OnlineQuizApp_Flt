import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../UserDashboard.dart';

class AddQuestionScreen extends StatefulWidget {
  final String accessToken;
  final int quizId;

  const AddQuestionScreen({
    Key? key,
    required this.accessToken,
    required this.quizId,
  }) : super(key: key);

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  TextEditingController _questionTextController = TextEditingController();
  TextEditingController _option1Controller = TextEditingController();
  TextEditingController _option2Controller = TextEditingController();
  TextEditingController _option3Controller = TextEditingController();
  TextEditingController _option4Controller = TextEditingController();
  TextEditingController _correctOptionIndexController = TextEditingController();

  Future<void> _addQuestion() async {
    final url = Uri.parse('http://192.168.56.1:23901/api/v2/auth/${widget.quizId}');
    final body = jsonEncode({
      'questionText': _questionTextController.text,
      'options': [
        _option1Controller.text,
        _option2Controller.text,
        _option3Controller.text,
        _option4Controller.text,
      ],
      'correctOptionIndex': int.parse(_correctOptionIndexController.text),
    });

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.accessToken}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        // Question added successfully
        print('Question added successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Question added successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        // Clear text fields after successful addition
        _questionTextController.clear();
        _option1Controller.clear();
        _option2Controller.clear();
        _option3Controller.clear();
        _option4Controller.clear();
        _correctOptionIndexController.clear();

        // Clear text fields after successful addition within setState
        // setState(() {
        //   _questionTextController.clear();
        //   _option1Controller.clear();
        //   _option2Controller.clear();
        //   _option3Controller.clear();
        //   _option4Controller.clear();
        //   _correctOptionIndexController.clear();
        // });
      } else {
        // Handle other status codes (e.g., 4xx, 5xx)
        print('Failed to add question: ${response.statusCode}');
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add question: ${response.statusCode}'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error adding question: $e');
      // Show a generic error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding question. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _questionTextController,
              decoration: InputDecoration(
                labelText: 'Question Text',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _option1Controller,
              decoration: InputDecoration(
                labelText: 'Option 1',
              ),
            ),
            TextField(
              controller: _option2Controller,
              decoration: InputDecoration(
                labelText: 'Option 2',
              ),
            ),
            TextField(
              controller: _option3Controller,
              decoration: InputDecoration(
                labelText: 'Option 3',
              ),
            ),
            TextField(
              controller: _option4Controller,
              decoration: InputDecoration(
                labelText: 'Option 4',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _correctOptionIndexController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Correct Option Index (0-3)',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addQuestion();
              },
              child: Text('Add Question'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDashboard(accessToken: widget.accessToken),
                  ),
                );
              },
              child: Text('Done!'),
            ),
          ],
        ),
      ),
    );
  }
}
