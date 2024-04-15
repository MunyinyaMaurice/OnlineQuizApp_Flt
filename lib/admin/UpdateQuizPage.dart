import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateQuizPage extends StatefulWidget {
  final int quizId;

  const UpdateQuizPage({Key? key, required this.quizId}) : super(key: key);

  @override
  _UpdateQuizPageState createState() => _UpdateQuizPageState();
}

class _UpdateQuizPageState extends State<UpdateQuizPage> {
  late TextEditingController _titleController;
  bool _isLoading = true;
  List<TextEditingController> _questionControllers = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();

    // Fetch quiz data from API
    _fetchQuizData();
  }

  Future<void> _fetchQuizData() async {
    final url = Uri.parse('http://192.168.56.1:23901/api/v2/auth/quiz/${widget.quizId}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final quizData = jsonDecode(response.body);

        final String quizTitle = quizData['title'];
        _titleController.text = quizTitle;

        List<dynamic> questions = quizData['questions'];
        List<TextEditingController> questionControllers = [];

        questions.forEach((question) {
          TextEditingController questionController = TextEditingController(text: question['questionText']);
          questionControllers.add(questionController);
        });

        setState(() {
          _isLoading = false;
          _questionControllers = questionControllers;
        });
      } else {
        throw Exception('Failed to load quiz data');
      }
    } catch (e) {
      print('Error fetching quiz data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateQuiz() async {
    // Prepare updated quiz data based on input fields
    Map<String, dynamic> updatedQuizData = {
      'title': _titleController.text,
      'questions': _questionControllers.map((controller) {
        return {
          'questionText': controller.text,
          'options': ['Option 1', 'Option 2', 'Option 3', 'Option 4'], // Example options, customize as needed
          'correctOptionIndex': 0, // Default correct option index, customize based on user input
        };
      }).toList(),
    };

    // Send updated quiz data to API for updating
    final url = Uri.parse('http://192.168.56.1:23901/api/v2/auth/quiz/${widget.quizId}');

    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedQuizData),
      );

      if (response.statusCode == 200) {
        // Quiz updated successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quiz updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('Failed to update quiz');
      }
    } catch (e) {
      print('Error updating quiz: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update quiz'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Quiz'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Quiz Title'),
            ),
            SizedBox(height: 20),
            Text(
              'Questions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: _buildQuestionFields(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateQuiz,
              child: Text('Update Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildQuestionFields() {
    return _questionControllers.map((controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Question'),
          ),
          SizedBox(height: 10),
          // Add input fields for options and correct option index
          TextFormField(
            decoration: InputDecoration(labelText: 'Option 1'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Option 2'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Option 3'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Option 4'),
          ),
          SizedBox(height: 10),
        ],
      );
    }).toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _questionControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}



// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class UpdateQuizPage extends StatefulWidget {
//   final int quizId;
//
//   const UpdateQuizPage({Key? key, required this.quizId}) : super(key: key);
//
//   @override
//   _UpdateQuizPageState createState() => _UpdateQuizPageState();
// }
//
// class _UpdateQuizPageState extends State<UpdateQuizPage> {
//   late TextEditingController _titleController;
//   bool _isLoading = true;
//   List<TextEditingController> _questionControllers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController();
//
//     // Fetch quiz data from API
//     _fetchQuizData();
//   }
//
//   Future<void> _fetchQuizData() async {
//     final url = Uri.parse('http://192.168.56.1:23901/api/v2/auth/quiz/${widget.quizId}');
//
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final quizData = jsonDecode(response.body);
//
//         final String quizTitle = quizData['title'] as String;
//         _titleController.text = quizTitle;
//
//         List<dynamic> questions = quizData['questions'];
//         List<TextEditingController> questionControllers = [];
//
//         questions.forEach((question) {
//           TextEditingController questionController =
//           TextEditingController(text: question['questionText'] as String);
//           questionControllers.add(questionController);
//
//           int correctOptionIndex = 0; // Default value
//           if (question.containsKey('correctOptionIndex')) {
//             if (question['correctOptionIndex'] is int) {
//               correctOptionIndex = question['correctOptionIndex'];
//             } else if (question['correctOptionIndex'] is String) {
//               try {
//                 correctOptionIndex = int.parse(question['correctOptionIndex']);
//               } catch (e) {
//                 print('Error parsing correctOptionIndex: $e');
//               }
//             }
//           }
//
//           // Additional logic to handle options if needed
//         });
//
//         setState(() {
//           _isLoading = false;
//           _questionControllers = questionControllers;
//         });
//       } else {
//         throw Exception('Failed to load quiz data');
//       }
//     } catch (e) {
//       print('Error fetching quiz data: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Update Quiz'),
//       ),
//       body: _isLoading
//           ? Center(
//         child: CircularProgressIndicator(),
//       )
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextFormField(
//               controller: _titleController,
//               decoration: InputDecoration(labelText: 'Quiz Title'),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Questions:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Column(
//               children: _buildQuestionFields(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<Widget> _buildQuestionFields() {
//     return _questionControllers.map((controller) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextFormField(
//             controller: controller,
//             decoration: InputDecoration(labelText: 'Question ${_questionControllers.indexOf(controller) + 1}'),
//           ),
//           SizedBox(height: 10),
//           // Add more fields for options and correct answer handling
//         ],
//       );
//     }).toList();
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _questionControllers.forEach((controller) => controller.dispose());
//     super.dispose();
//   }
// }
