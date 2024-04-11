import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuizResultPage extends StatefulWidget {
  final int quizId;
  final Map<String, String> selectedOptions;

  const QuizResultPage({
    Key? key,
    required this.quizId,
    required this.selectedOptions,
  }) : super(key: key);

  @override
  _QuizResultPageState createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  int _quizResultId = 0;
  int _quizMarks = 0;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchQuizResult();
  }

  Future<void> _fetchQuizResult() async {
    final Uri uri = Uri.parse(
        'http://192.168.56.1:23901/api/v2/auth/quiz-results/result?quizId=${widget.quizId}');

    try {
      final http.Response response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          _quizResultId = responseData['id'];
          _quizMarks = responseData['marks'];
          _isLoading = false;
          _hasError = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        print('Failed to fetch quiz result. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      print('Error occurred while fetching quiz result: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(
        child: Text(
          'Failed to load quiz result.',
          style: TextStyle(color: Colors.red),
        ),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Result',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Quiz Result ID: $_quizResultId'),
            Text('Marks Obtained: $_quizMarks'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to previous screen (QuizPage)
              },
              child: Text('Back to Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
