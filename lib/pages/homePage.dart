import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sign_in/pages/addQuestion.dart';
import 'package:sign_in/pages/technique.dart';

import 'viewQuestion.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  fetchQuestions() async {
    Uri url = Uri.parse("http://localhost:5000/discussion/getAllQuestions");
    try {
      var response = await http.post(url);
      if (response.statusCode == 200) {
        setState(() {
          questions = List<Map<String, dynamic>>.from(json.decode(response.body));
        });
      } else {
        print('Failed to load questions: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load questions')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading questions: $e')),
      );
    }
  }

  void refreshQuestions() {
    fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MentalWellness'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Text('Profile Updating'),
              ),
              const PopupMenuItem(
                value: 'add_service',
                child: Text('Add Service'),
              ),
              const PopupMenuItem(
                value: 'appointment_booking',
                child: Text('Appointment Booking'),
              ),
              const PopupMenuItem(
                value: 'download_reports',
                child: Text('Download Reports'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddQuestion()),
              ).then((value) {
                refreshQuestions();
              });
            },
            child: Text('Ask Your Question'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(questions[index]['title'] ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewQuestionPage(
                          question: questions[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          Row(
            children: [
              Text("Tips to improve your mental health!"),
              SizedBox(width: 20,),
              OutlinedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.blue[100])
                ),
                onPressed: (){Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => TechniquePage(
                      techniqueName: "Tip 1")
                  )
                );}, child: Text("Tip 1")),
                SizedBox(width: 20,),
                OutlinedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.blue[100])
                ),
                onPressed: (){Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => TechniquePage(
                      techniqueName: "Tip 2")
                  )
                );}, child: Text("Tip 2")),
                SizedBox(width: 20,),
                OutlinedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.blue[100])
                ),
                onPressed: (){Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => TechniquePage(
                      techniqueName: "Tip 3")
                  )
                );}, child: Text("Tip 3")),
            ],
          ),
        ],
      ),
    );
  }
}
