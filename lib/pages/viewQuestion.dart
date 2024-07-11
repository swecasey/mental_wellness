import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewQuestionPage extends StatefulWidget {
  final Map<String, dynamic> question;

  const ViewQuestionPage({Key? key, required this.question}) : super(key: key);

  @override
  _ViewQuestionPageState createState() => _ViewQuestionPageState();
}

class _ViewQuestionPageState extends State<ViewQuestionPage> {
  List<dynamic> answers = [];
  TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAnswers();
  }

  void fetchAnswers() async {
    Uri url = Uri.parse("http://localhost:5000/discussion/getAnswers");
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'questionId': widget.question['questionId']}),
      );
      if (response.statusCode == 200) {
        setState(() {
          answers = json.decode(response.body);
        });
      } else {
        print('Failed to load answers: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load answers')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading answers: $e')),
      );
    }
  }

  void postAnswer() async {
    String answerText = answerController.text.trim();
    if (answerText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an answer')),
      );
      return;
    }

    Map<String, dynamic> data = {
      'questionId': widget.question['questionId'],
      'counsellorId': 1, // Placeholder for counsellorId
      'answer': answerText,
    };

    Uri url = Uri.parse("http://localhost:5000/discussion/answerQuestion");
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Answer posted successfully')),
        );
        answerController.clear();
        fetchAnswers(); // Refresh answers after posting
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post answer')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network Error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              widget.question['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              widget.question['description'],
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 24),
            Text(
              'Answers:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: answers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(answers[index]['answer']),
                  subtitle: Text('Answered by: Counsellor ${answers[index]['counsellorId']}'),
                );
              },
            ),
            SizedBox(height: 24),
            Text(
              'Post Your Answer:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            TextField(
              controller: answerController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type your answer here',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: postAnswer,
              child: Text('Post Answer'),
            ),
          ],
        ),
      ),
    );
  }
}
