

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuizPage extends StatefulWidget {
  final int quizId;
  final String accessToken;

  const QuizPage({Key? key, required this.quizId, required this.accessToken})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<String> _quizQuestions = [];

  @override
  void initState() {
    super.initState();
    _fetchQuizQuestions();
  }Future<void> _fetchQuizQuestions() async {
    final Uri uri = Uri.parse('http://192.168.56.1:23901/api/v2/auth/questions/${widget.quizId}');

    try {
      final http.Response response = await http.get(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final String quizContent = response.body;
        // Split the quiz content into individual questions
        List<String> questions = quizContent.split('\n\n');
        setState(() {
          _quizQuestions = questions;
        });
      } else {
        print('Failed to fetch quiz questions. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while fetching quiz questions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: _quizQuestions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _quizQuestions.length,
        itemBuilder: (context, index) {
          final question = _quizQuestions[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${index + 1}: ${question.split('\n')[0]}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var option in question.split('\n').skip(1))
                      Text(option),
                  ],
                ),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
