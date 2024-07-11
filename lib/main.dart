import 'package:flutter/material.dart';
import 'package:sign_in/pages/signIn.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign In',
      home: SignIn()
      );
  }
}