import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'QuizResultPage.dart';

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
  bool _isLoading = true;
  bool _hasError = false;
  Map<String, dynamic> _answeredQuestions = {};

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
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('body') &&
            responseData['body'] is Map<String, dynamic>) {
          final Map<String, dynamic> body = responseData['body'];

          List<Map<String, dynamic>> quizQuestions = [];

          body.forEach((key, value) {
            if (value is Map<String, dynamic> &&
                value.containsKey('questionId') &&
                value.containsKey('question') &&
                value.containsKey('options')) {
              quizQuestions.add({
                'questionId': value['questionId'],
                'question': value['question'],
                'options': value['options'],
              });
            }
          });

          setState(() {
            _quizQuestions = quizQuestions;
            _isLoading = false;
            _hasError = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
          print('Invalid quiz data format in the API response.');
        }
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        print(
            'Failed to fetch quiz questions. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      print('Error occurred while fetching quiz questions: $e');
    }
  }

  void _nextQuestion() {
    if (_currentPageIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentPageIndex++;
      });
    }
  }

  void _submitQuiz() async {
    print('Submitting quiz...');

    String submitUrl =
        'http://192.168.56.1:23901/api/v2/auth/submit/${widget.quizId}';

    try {
      Map<String, dynamic> submittedAnswers = {};

      _answeredQuestions.forEach((key, value) {
        // int questionNumber = int.parse(key) + 1;
        int questionNumber = int.parse(key) ;
        submittedAnswers[questionNumber.toString()] = value;
      });

      String jsonAnswers = json.encode(submittedAnswers);
      print('Formatted Answers: $jsonAnswers');

      final http.Response response = await http.post(
        Uri.parse(submitUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
        body: jsonAnswers,
      );
      if (response.statusCode == 200) {
        print('Quiz submitted successfully');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Quiz Submitted'),
              content: Text('Quiz has been submitted successfully.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizResultPage(
                          quizId: widget.quizId,
                          accessToken: widget.accessToken,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Failed to submit quiz. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred during quiz submission: $e');
    }
  }

  Widget _buildQuiz() {
    final currentQuestion = _quizQuestions[_currentPageIndex];
    final int questionId = currentQuestion['questionId'] ?? 0;
    final String question = currentQuestion['question'] ?? '';
    final List<dynamic> options = currentQuestion['options'] ?? [];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Text(
          //   '${questionId.toString()} . ',
          //   style: TextStyle(fontSize: 20),
          //   textAlign: TextAlign.center,
          // ),
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
                  setState(() {
                    _answeredQuestions[questionId.toString()] = option;
                    _nextQuestion();
                  });
                },
                child: Text(option.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          if (_currentPageIndex == _quizQuestions.length - 1)
            ElevatedButton(
              onPressed: () {
                _submitQuiz();
              },
              child: Text('Submit Quiz'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Page'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(
        child: Text(
          'Failed to load quiz questions.',
          style: TextStyle(color: Colors.red),
        ),
      )
          : _quizQuestions.isEmpty
          ? Center(
        child: Text(
          'No questions available.',
          style: TextStyle(color: Colors.grey),
        ),
      )
          : _buildQuiz(),
    );
  }
}


//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import 'QuizResultPage.dart';
// // import 'QuizResultPage.dart';
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
//   List<Map<String, dynamic>> _quizQuestions = [];
//   int _currentPageIndex = 0;
//   bool _isLoading = true;
//   bool _hasError = false;
//   Map<String, dynamic> _answeredQuestions = {}; // Use Map<String, dynamic> for selected options
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchQuizQuestions();
//   }
//
//   Future<void> _fetchQuizQuestions() async {
//     final Uri uri = Uri.parse(
//         'http://192.168.56.1:23901/api/v2/auth/questions/${widget.quizId}');
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
//         final Map<String, dynamic> responseData = json.decode(response.body);
//
//         if (responseData.containsKey('body') &&
//             responseData['body'] is Map<String, dynamic>) {
//           final Map<String, dynamic> body = responseData['body'];
//
//           List<Map<String, dynamic>> quizQuestions = [];
//
//           body.forEach((key, value) {
//             if (value is Map<String, dynamic> &&
//                 value.containsKey('question') &&
//                 value.containsKey('options')) {
//               quizQuestions.add({
//                 'question': value['question'] ?? '',
//                 'options': value['options'] ?? [],
//               });
//             }
//           });
//
//           setState(() {
//             _quizQuestions = quizQuestions;
//             _isLoading = false;
//             _hasError = false;
//           });
//         } else {
//           setState(() {
//             _isLoading = false;
//             _hasError = true;
//           });
//           print('Invalid quiz data format in the API response.');
//         }
//       } else {
//         setState(() {
//           _isLoading = false;
//           _hasError = true;
//         });
//         print(
//             'Failed to fetch quiz questions. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//       });
//       print('Error occurred while fetching quiz questions: $e');
//     }
//   }
//
//   Widget _buildQuiz() {
//     final currentQuestion = _quizQuestions[_currentPageIndex];
//     final int questionId = currentQuestion['questionId'];
//     final String question = currentQuestion['question'];
//     final List<dynamic> options = currentQuestion['options'];
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Text(
//             '${questionId} . ',
//             style: TextStyle(fontSize: 20),
//             textAlign: TextAlign.center,
//           ),
//           Text(
//             question,
//             style: TextStyle(fontSize: 20),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 20),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: options.map<Widget>((option) {
//               return ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     // _answeredQuestions[_currentPageIndex.toString()] = option;
//                     _answeredQuestions[questionId.toString()] = option;
//                     _nextQuestion();
//                   });
//                 },
//                 child: Text(option.toString()),
//               );
//             }).toList(),
//           ),
//           SizedBox(height: 20),
//           if (_currentPageIndex == _quizQuestions.length - 1)
//             ElevatedButton(
//               onPressed: () {
//                 _submitQuiz();
//               },
//               child: Text('Submit Quiz'),
//             ),
//         ],
//       ),
//     );
//   }
//
//   void _nextQuestion() {
//     if (_currentPageIndex < _quizQuestions.length - 1) {
//       setState(() {
//         _currentPageIndex++;
//       });
//     }
//   }
//   void _submitQuiz() async {
//     print('Submitting quiz...');
//
//     // Prepare the endpoint URL
//     String submitUrl = 'http://192.168.56.1:23901/api/v2/auth/submit/${widget.quizId}';
//
//     try {
//       // Prepare the map to hold submitted answers
//       Map<String, dynamic> submittedAnswers = {};
//
//       // Loop through answered questions map
//       _answeredQuestions.forEach((key, value) {
//         // Use question index as key (converted to string)
//         int questionNumber = int.parse(key) + 1; // Convert key to int and add 1
//         submittedAnswers[questionNumber.toString()] = value;
//
//         // submittedAnswers[key] = value;
//       });
//
//       // Convert submitted answers map to JSON
//       String jsonAnswers = json.encode(submittedAnswers);
//       print('Formatted Answers: $jsonAnswers');
//
//       // Make POST request to submit quiz
//       final http.Response response = await http.post(
//         Uri.parse(submitUrl),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${widget.accessToken}',
//         },
//         body: jsonAnswers,
//       );
//       if (response.statusCode == 200) {
//         print('Quiz submitted successfully');
//
//         // Show dialog to notify user
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Quiz Submitted'),
//               content: Text('Quiz has been submitted successfully.'),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('OK'),
//                   onPressed: () {
//                     // Close dialog
//                     Navigator.of(context).pop();
//
//                     // Navigate to QuizResultPage
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => QuizResultPage(
//                           quizId: widget.quizId,
//                           accessToken: widget.accessToken,
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//
//         // if (response.statusCode == 200) {
//         //   print('Quiz submitted successfully');
//         //   // Handle navigation or other actions upon successful submission
//       } else {
//         print('Failed to submit quiz. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         // Handle failure scenario accordingly
//       }
//     } catch (e) {
//       print('Error occurred during quiz submission: $e');
//       // Handle error scenario accordingly
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz Page'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _hasError
//           ? Center(
//         child: Text(
//           'Failed to load quiz questions.',
//           style: TextStyle(color: Colors.red),
//         ),
//       )
//           : _quizQuestions.isEmpty
//           ? Center(
//         child: Text(
//           'No questions available.',
//           style: TextStyle(color: Colors.grey),
//         ),
//       )
//           : _buildQuiz(),
//     );
//   }
// }
