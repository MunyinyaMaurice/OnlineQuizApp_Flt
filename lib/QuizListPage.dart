import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuizListPage extends StatefulWidget {
  const QuizListPage({Key? key}) : super(key: key);

  @override
  _QuizListPageState createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  List<dynamic> _quizList = [];

  @override
  void initState() {
    super.initState();
    _fetchQuizList();
  }

  Future<void> _fetchQuizList() async {
    final Uri uri = Uri.parse('http://192.168.137.1:23901/api/v2/auth/all_quiz');

    try {
      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> quizList = json.decode(response.body);
        setState(() {
          _quizList = quizList;
        });
      } else {
        // Handle error responses
        print('Failed to fetch quiz list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Error occurred while fetching quiz list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Quizzes'),
      ),
      body: _quizList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _quizList.length,
        itemBuilder: (context, index) {
          final quiz = _quizList[index];
          return ListTile(
            tileColor: Colors.lightBlueAccent, // Use sky-blue as the background color
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Make the text bold
                          color: Colors.white, // Set text color to white
                        ),
                      ),
                      SizedBox(height: 5), // Add some space between the title and subtitle
                      Text(
                        'ID: ${quiz['id']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // Make the text bold
                          color: Colors.white, // Set text color to white
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement button onPressed logic here
                  },
                  child: Text(
                    'Start Now',
                    style: TextStyle(
                      color: Colors.white, // Set text color to white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Set button background color to blue
                  ),
                ),
              ],
            ),
          );


        },
      ),
    );
  }
}