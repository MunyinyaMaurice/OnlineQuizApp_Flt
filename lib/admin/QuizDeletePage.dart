import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuizDeletePage extends StatelessWidget {
  final int quizId;

  const QuizDeletePage({Key? key, required this.quizId}) : super(key: key);

  Future<void> deleteQuiz(BuildContext context) async {
    final url = Uri.parse('http://192.168.56.1:23901/api/v2/auth/quiz/$quizId');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Quiz deleted successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quiz deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Optionally navigate to another screen after successful deletion
        // Navigator.of(context).pop();
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
        title: Text('Delete Quiz'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Confirm Deletion'),
                  content: Text('Are you sure you want to delete this quiz?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        deleteQuiz(context);
                        Navigator.of(context).pop();
                      },
                      child: Text('Delete'),
                    ),
                  ],
                );
              },
            );
          },
          child: Text('Delete Quiz'),
        ),
      ),
    );
  }
}
