// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'QuizResultPage.dart';
//
// class QuizPage extends StatefulWidget {
//   final int quizId;
//   final String accessToken;
//
//   const QuizPage({
//     Key? key,
//     required this.quizId,
//     required this.accessToken,
//   }) : super(key: key);
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
//   Map<String, dynamic> _answeredQuestions = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchQuizQuestions();
//   }
//
//   Future<void> _fetchQuizQuestions() async {
//     final Uri uri = Uri.parse(
//       'http://192.168.56.1:23901/api/v2/auth/questions/${widget.quizId.toString()}',
//     );
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
//           'Failed to fetch quiz questions. Status code: ${response.statusCode}',
//         );
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
//                     _answeredQuestions[_currentPageIndex.toString()] =
//                         option.toString();
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
//
//   void _submitQuiz() async {
//     Map<String, String> stringKeyedAnswers = {};
//     _answeredQuestions.forEach((key, value) {
//       stringKeyedAnswers[key] = value.toString();
//     });
//
//     Map<String, dynamic> submissionData = {
//       'quizId': widget.quizId,
//       'answers': stringKeyedAnswers,
//     };
//
//     String jsonData = json.encode(submissionData);
//
//     final Uri uri = Uri.parse(
//       'http://192.168.56.1:23901/api/v2/auth/end/${widget.quizId.toString()}',
//     );
//
//     try {
//       final http.Response response = await http.post(
//         uri,
//         headers: <String, String>{
//           'Authorization': 'Bearer ${widget.accessToken}',
//           'Content-Type': 'application/json',
//         },
//         body: jsonData,
//       );
//
//       if (response.statusCode == 200) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => QuizResultPage(
//               quizId: widget.quizId,
//               selectedOptions: stringKeyedAnswers,
//             ),
//           ),
//         );
//       } else {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Submission Failed'),
//             content: Text('Failed to submit quiz. Please try again.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     } catch (e) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text('An error occurred while submitting quiz: $e'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz Page'),
//       ),
//       body: _isLoading
//           ? Center(
//         child: CircularProgressIndicator(),
//       )
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
  Map<String, dynamic> _answeredQuestions = {}; // Use Map<String, dynamic> for selected options

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
                value.containsKey('question') &&
                value.containsKey('options')) {
              quizQuestions.add({
                'question': value['question'] ?? '',
                'options': value['options'] ?? [],
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

  Widget _buildQuiz() {
    final currentQuestion = _quizQuestions[_currentPageIndex];
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
                  setState(() {
                    _answeredQuestions[_currentPageIndex.toString()] = option;
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

  void _nextQuestion() {
    if (_currentPageIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentPageIndex++;
      });
    }
  }
  void _submitQuiz() async {
    // Process the quiz submission here
    print('Submitting quiz...');

    // Create a new map with keys starting from 1
    Map<String, dynamic> formattedAnswers = {};
    _answeredQuestions.forEach((key, value) {
      int questionNumber = int.parse(key) + 1; // Convert key to int and add 1
      formattedAnswers[questionNumber.toString()] = value;
    });

    // Convert to JSON
    String jsonAnswers = json.encode(formattedAnswers);
    print('Formatted Answers: $jsonAnswers');

    // Prepare the endpoint URL
    String submitUrl = 'http://192.168.56.1:23901/api/v2/auth/submit/${widget.quizId}';

    try {
      // Make POST request to submit quiz
      final http.Response response = await http.post(
        Uri.parse(submitUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.accessToken}',
        },
        body: jsonAnswers,
      );

      if (response.statusCode == 200) {
        // Quiz submitted successfully
        print('Quiz submitted successfully');
        // Navigate to the result page or perform any other actions
      } else {
        // Quiz submission failed
        print('Failed to submit quiz. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Handle error scenario accordingly
      }
    } catch (e) {
      // Error occurred during quiz submission
      print('Error occurred during quiz submission: $e');
      // Handle error scenario accordingly
    }
  }

  // void _submitQuiz() {
  //   // Process the quiz submission here
  //   print('Submitting quiz...');
  //
  //   // Create a new map with keys starting from 1
  //   Map<String, dynamic> formattedAnswers = {};
  //   _answeredQuestions.forEach((key, value) {
  //     int questionNumber = int.parse(key) + 1; // Convert key to int and add 1
  //     formattedAnswers[questionNumber.toString()] = value;
  //   });
  //
  //   // Convert to JSON
  //   String jsonAnswers = json.encode(formattedAnswers);
  //   print('Formatted Answers: $jsonAnswers');
  //
  //   // You can implement the submission logic based on your requirements
  // }

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

//       1
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'QuizResultPage.dart';
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
//                     _answeredQuestions[_currentPageIndex.toString()] = option;
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
//   void _submitQuiz() {
//     // Process the quiz submission here
//     print('Submitting quiz...');
//
//     // Create a new map with keys starting from 1
//     Map<String, dynamic> formattedAnswers = {};
//     _answeredQuestions.forEach((key, value) {
//       int questionNumber = int.parse(key) + 1; // Convert key to int and add 1
//       formattedAnswers[questionNumber.toString()] = value;
//     });
//
//     // Convert to JSON
//     String jsonAnswers = json.encode(formattedAnswers);
//     print('Formatted Answers: $jsonAnswers');
//
//     // You can implement the submission logic based on your requirements
//   }
//
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

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'QuizResultPage.dart';
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
//   Map<String, String> _answeredQuestions = {}; // Use Map<String, String> for selected options
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
//                     _answeredQuestions[_currentPageIndex.toString()] =
//                         option.toString();
//                     _nextQuestion();
//                   });
//                 },
//                 child: Text(option.toString()),
//               );
//             }).toList(),
//           ),
//           SizedBox(height: 20),
//           // Show button only when all questions are answered
//           if (_currentPageIndex == _quizQuestions.length - 1)
//             ElevatedButton(
//               onPressed: () {
//                 _submitQuiz(); // This will navigate to QuizResultPage
//               },
//               child: Text('See Result'),
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
//     } else {
//       // All questions answered, do nothing
//     }
//   }
//
//   void _submitQuiz() {
//     // Convert _answeredQuestions to Map<String, String> before passing to QuizResultPage
//     Map<String, String> stringKeyedAnswers = {};
//     _answeredQuestions.forEach((key, value) {
//       stringKeyedAnswers[key] = value.toString();
//     });
//
//     // Navigate to QuizResultPage with quizId and selected options
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => QuizResultPage(
//           quizId: widget.quizId,
//           selectedOptions: stringKeyedAnswers,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz Page'),
//       ),
//       body: _isLoading
//           ? Center(
//         child: CircularProgressIndicator(),
//       )
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


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import 'QuizResultPage.dart';
// // import 'quizResultPage.dart'; // Import the QuizResultPage
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
//   Map<int, String> _answeredQuestions = {};
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz Page'),
//       ),
//       body: _isLoading
//           ? Center(
//         child: CircularProgressIndicator(),
//       )
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
//
//   Widget _buildQuiz() {
//     final currentQuestion = _quizQuestions[_currentPageIndex];
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
//                     _answeredQuestions[_currentPageIndex + 1] = option.toString();
//                     _nextQuestion();
//                   });
//                 },
//                 child: Text(option.toString()),
//               );
//             }).toList(),
//           ),
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
//     } else {
//       // All questions answered, navigate to QuizResultPage
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => QuizResultPage(
//       //       quizId: widget.quizId,
//       //       accessToken: widget.accessToken,
//       //       // answeredQuestions: _answeredQuestions,
//       //     ),
//       //   ),
//       // );
//       // Inside QuizPage where you navigate to QuizResultPage upon quiz completion
//       void _submitQuiz() {
//         // Assuming quiz is completed and _answeredQuestions map is filled
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => QuizResultPage(
//               quizId: widget.quizId,        // Pass the quizId
//               accessToken: widget.accessToken,  // Pass the accessToken
//             ),
//           ),
//         );
//       }
//     }
//   }
// }
//


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
//   List<Map<String, dynamic>> _quizQuestions = [];
//   int _currentPageIndex = 0;
//   bool _isLoading = true;
//   bool _hasError = false;
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz Page'),
//       ),
//       body: _isLoading
//           ? Center(
//         child: CircularProgressIndicator(),
//       )
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
//
//   Widget _buildQuiz() {
//     final currentQuestion = _quizQuestions[_currentPageIndex];
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
//                   _nextQuestion();
//                 },
//                 child: Text(option),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _nextQuestion() {
//     setState(() {
//       if (_currentPageIndex < _quizQuestions.length - 1) {
//         _currentPageIndex++;
//       } else {
//         _showQuizCompletionDialog();
//       }
//     });
//   }
//
//   void _showQuizCompletionDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Quiz Completed'),
//           content: Text('Congratulations! You have completed the quiz.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }



