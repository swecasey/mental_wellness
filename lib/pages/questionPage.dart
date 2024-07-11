import 'package:flutter/material.dart';

class QuestionPage extends StatelessWidget {
  final Map<String, dynamic> data; // Define data variable to receive data

  QuestionPage({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = data['title']; // Extract 'title' from data
    String description = data['description']; // Extract 'description' from data

    return Scaffold(
      appBar: AppBar(
        title: Text('Question Details'),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Title: $title', // Display title
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Description: $description', // Display description
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
