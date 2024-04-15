import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quizapp_flutter/admin/UpdateQuizPage.dart';

class QuizListWithQuestionsScreen extends StatefulWidget {
  final String accessToken;

  const QuizListWithQuestionsScreen({Key? key, required this.accessToken})
      : super(key: key);

  @override
  _QuizListWithQuestionsScreenState createState() =>
      _QuizListWithQuestionsScreenState();
}

class _QuizListWithQuestionsScreenState
    extends State<QuizListWithQuestionsScreen> {
  List<dynamic> _quizListWithQuestions = [];

  @override
  void initState() {
    super.initState();
    _fetchQuizListWithQuestions();
  }

  Future<void> _fetchQuizListWithQuestions() async {
    final url =
    Uri.parse('http://192.168.56.1:23901/api/v2/auth/with-questions');

    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> quizListWithQuestions =
        json.decode(response.body);
        setState(() {
          _quizListWithQuestions = quizListWithQuestions;
        });
      } else {
        throw Exception('Failed to load quiz list with questions');
      }
    } catch (e) {
      print('Error fetching quiz list with questions: $e');
    }
  }

  Future<void> _navigateToUpdateQuiz(int quizId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateQuizPage(quizId: quizId),
      ),
    );
    // After updating, refresh the quiz list
    _fetchQuizListWithQuestions();
  }

  Future<void> _confirmDeleteQuiz(int quizId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this quiz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteQuiz(quizId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteQuiz(int quizId) async {
    final url =
    Uri.parse('http://192.168.56.1:23901/api/v2/auth/quiz/$quizId');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 204) {
        // Quiz deleted successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quiz deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh quiz list after deletion
        _fetchQuizListWithQuestions();
      } else {
        throw Exception('Failed to delete quiz');
      }
    } catch (e) {
      print('Error deleting quiz: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete quiz'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzes with Questions'),
      ),
      body: SingleChildScrollView(
        child: _quizListWithQuestions.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _quizListWithQuestions.map((quiz) {
            final quizId = quiz['id'];
            return Card(
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          quiz['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _navigateToUpdateQuiz(quizId);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _confirmDeleteQuiz(quizId);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.0),
                    (quiz['questions'] as List<dynamic>).isEmpty
                        ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'No questions available for this quiz.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                      (quiz['questions'] as List<dynamic>)
                          .length,
                      itemBuilder: (context, index) {
                        final question =
                        quiz['questions'][index] as Map<String, dynamic>;
                        final List<dynamic> options =
                        question['options'];
                        final int correctOptionIndex =
                        question['correctOptionIndex'];

                        return Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question ${index + 1}: ${question['questionText']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4.0),
                            options.isEmpty
                                ? Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.0),
                              child: Text(
                                'No options available for this question.',
                                style: TextStyle(
                                    color: Colors.grey),
                              ),
                            )
                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                for (var option in options)
                                  Text('- $option'),
                              ],
                            ),
                            SizedBox(height: 4.0),
                            correctOptionIndex >= 0 &&
                                correctOptionIndex <
                                    options.length
                                ? Text(
                              'Correct Option: ${options[correctOptionIndex]}',
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold),
                            )
                                : Text(
                              'Correct Option: Not available',
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                            SizedBox(height: 12.0),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class QuizListWithQuestionsScreen extends StatefulWidget {
//   final String accessToken;
//
//   const QuizListWithQuestionsScreen({Key? key, required this.accessToken})
//       : super(key: key);
//
//   @override
//   _QuizListWithQuestionsScreenState createState() =>
//       _QuizListWithQuestionsScreenState();
// }
//
// class _QuizListWithQuestionsScreenState
//     extends State<QuizListWithQuestionsScreen> {
//    List<dynamic> _quizListWithQuestions = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchQuizListWithQuestions();
//   }
//
//   Future<void> _fetchQuizListWithQuestions() async {
//     final url = Uri.parse('http://192.168.56.1:23901/api/v2/auth/with-questions');
//
//     try {
//       final response = await http.get(
//         url,
//         headers: <String, String>{
//           'Authorization': 'Bearer ${widget.accessToken}',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> quizListWithQuestions =
//         json.decode(response.body);
//         setState(() {
//           _quizListWithQuestions = quizListWithQuestions;
//         });
//       } else {
//         throw Exception('Failed to load quiz list with questions');
//       }
//     } catch (e) {
//       print('Error fetching quiz list with questions: $e');
//     }
//   }
//    @override
//    Widget build(BuildContext context) {
//      return Scaffold(
//        appBar: AppBar(
//          title: Text('Quizzes with Questions'),
//        ),
//        body: SingleChildScrollView(
//          child: _quizListWithQuestions.isEmpty
//              ? Center(child: CircularProgressIndicator())
//              : Column(
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            children: _quizListWithQuestions.map((quiz) {
//              return Card(
//                margin: EdgeInsets.all(16.0),
//                child: Padding(
//                  padding: EdgeInsets.all(12.0),
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                      Text(
//                        quiz['title'],
//                        style: TextStyle(
//                          fontSize: 18,
//                          fontWeight: FontWeight.bold,
//                        ),
//                      ),
//                      SizedBox(height: 12.0),
//                      (quiz['questions'] as List<dynamic>).isEmpty
//                          ? Padding(
//                        padding: EdgeInsets.symmetric(vertical: 8.0),
//                        child: Text(
//                          'No questions available for this quiz.',
//                          style: TextStyle(color: Colors.grey),
//                        ),
//                      )
//                          : ListView.builder(
//                        shrinkWrap: true,
//                        physics: NeverScrollableScrollPhysics(),
//                        itemCount:
//                        (quiz['questions'] as List<dynamic>).length,
//                        itemBuilder: (context, index) {
//                          final question =
//                          quiz['questions'][index] as Map<String, dynamic>;
//                          final List<dynamic> options = question['options'];
//                          final int correctOptionIndex =
//                          question['correctOptionIndex'];
//
//                          return Column(
//                            crossAxisAlignment:
//                            CrossAxisAlignment.start,
//                            children: [
//                              Text(
//                                'Question ${index + 1}: ${question['questionText']}',
//                                style:
//                                TextStyle(fontWeight: FontWeight.bold),
//                              ),
//                              SizedBox(height: 4.0),
//                              options.isEmpty
//                                  ? Padding(
//                                padding: EdgeInsets.symmetric(vertical: 4.0),
//                                child: Text(
//                                  'No options available for this question.',
//                                  style: TextStyle(color: Colors.grey),
//                                ),
//                              )
//                                  : Column(
//                                crossAxisAlignment:
//                                CrossAxisAlignment.start,
//                                children: [
//                                  for (var option in options)
//                                    Text('- $option'),
//                                ],
//                              ),
//                              SizedBox(height: 4.0),
//                              correctOptionIndex >= 0 &&
//                                  correctOptionIndex < options.length
//                                  ? Text(
//                                'Correct Option: ${options[correctOptionIndex]}',
//                                style: TextStyle(fontWeight: FontWeight.bold),
//                              )
//                                  : Text(
//                                'Correct Option: Not available',
//                                style: TextStyle(fontWeight: FontWeight.bold),
//                              ),
//                              SizedBox(height: 12.0),
//                            ],
//                          );
//                        },
//                      ),
//                    ],
//                  ),
//                ),
//              );
//            }).toList(),
//          ),
//        ),
//      );
//    }
// }
