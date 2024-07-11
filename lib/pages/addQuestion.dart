import 'package:flutter/material.dart';
import 'package:sign_in/pages/homePage.dart';
import 'package:sign_in/pages/signIn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
Map userDetails = json.decode(profile);
class AddQuestion extends StatelessWidget {
   AddQuestion({super.key});

  final TextEditingController questSubController = TextEditingController();
  final TextEditingController questController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Center(
        child: Container(
          width: 300,
          height: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("ADD QUESTION",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 50,),
              Text("Add your problem"),
              TextField(
                controller: questSubController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2)
                  )
                ),
              ),
              Text("Describe your problem"),
              TextField(
                controller: questController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2)
                  )
                ),),
              TextButton(onPressed: (){askQuestAPI(context);}/*{askQuestAPI(context, onSuccess: (data) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestionPage(data:data)),
                      );
                    });}*/, child: Text("ADD")),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()
                )
                );
              }, child: Text("BACK")),
            ],
          ),
        ),
      ),
    );
  }
   //void askQuestAPI(BuildContext context,{required VoidCallback(Map<String, dynamic> data) onSuccess})async{
   void askQuestAPI(BuildContext context)async{
    if(questSubController.text.isEmpty  && questController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Oops,fields not complete")),
        );
    }
    else{
    String title = questSubController.text.trim();
    String description = questController.text.trim();
    int profileId = userDetails["profileId"];
    String clientId = profileId.toString();

    Map <String,String> data = {
      "clientId" : clientId,
      "title": title,
      "description": description,
    };
    Uri url = Uri.parse("http://localhost:5000/discussion/askQuestion");
    try {
      var response = await http.post(
        url,
        body: data,
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Question send Successfully')),
        );
        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage())
        
      );} else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Question sending Failed')),
        );
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network Error')),
      );
    }
  }
  }
}