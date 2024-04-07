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
  List<Map<String, dynamic>> _quizQuestions = [];
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchQuizQuestions();
  }

  Future<void> _fetchQuizQuestions() async {
    final Uri uri = Uri.parse(
        'http://192.168.56.1:23901/api/v2/auth/questions/${widget.quizId}');

    try {
      final http.Response response = await http.get(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> quizData = json.decode(response.body);
        List<Map<String, dynamic>> quizQuestions = [];

        quizData.forEach((key, value) {
          if (key.startsWith('Index ')) {
            quizQuestions.add(value);
          }
        });

        setState(() {
          _quizQuestions = quizQuestions;
        });
      } else {
        print(
            'Failed to fetch quiz questions. Status code: ${response.statusCode}');
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
        title: Text('Quiz Page'),
      ),
      body: _quizQuestions.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _buildQuiz(),
    );
  }

  Widget _buildQuiz() {
    final Map<String, dynamic> currentQuestion = _quizQuestions[_currentPageIndex];
    final String question = currentQuestion['question'];
    final List<dynamic> options = currentQuestion['options'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: options.map<Widget>((option) {
              return ElevatedButton(
                onPressed: () {
                  // Handle option selection logic here
                  // For example, you can navigate to the next question
                  _nextQuestion();
                },
                child: Text(option),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    setState(() {
      if (_currentPageIndex < _quizQuestions.length - 1) {
        _currentPageIndex++;
      } else {
        // Quiz completed
        _showQuizCompletionDialog();
      }
    });
  }

  void _showQuizCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Completed'),
          content: Text('Congratulations! You have completed the quiz.'),
          actions: [
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




// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class QuizPage extends StatefulWidget {
//   final int quizId;
//   final String accessToken;
//
//   const QuizPage({Key? key, required this.quizId, required this.accessToken})
//       : super(key: key);
//
//   @override
//   _QuizPageState createState() => _QuizPageState();
// }
//
// class _QuizPageState extends State<QuizPage> {
//   List<String> _quizQuestions = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchQuizQuestions();
//   }Future<void> _fetchQuizQuestions() async {
//     final Uri uri = Uri.parse('http://192.168.56.1:23901/api/v2/auth/questions/${widget.quizId}');
//
//     try {
//       final http.Response response = await http.get(
//         uri,
//         headers: <String, String>{
//           'Authorization': 'Bearer ${widget.accessToken}',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final String quizContent = response.body;
//         // Split the quiz content into individual questions
//         List<String> questions = quizContent.split('\n\n');
//         setState(() {
//           _quizQuestions = questions;
//         });
//       } else {
//         print('Failed to fetch quiz questions. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//       }
//     } catch (e) {
//       print('Error occurred while fetching quiz questions: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz'),
//       ),
//       body: _quizQuestions.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: _quizQuestions.length,
//         itemBuilder: (context, index) {
//           final question = _quizQuestions[index];
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Question ${index + 1}: ${question.split('\n')[0]}',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     for (var option in question.split('\n').skip(1))
//                       Text(option),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
