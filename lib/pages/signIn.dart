import 'package:flutter/material.dart';
import 'package:sign_in/pages/homePage.dart';
import 'package:sign_in/pages/signUp.dart';
import 'package:http/http.dart' as http;
var profile;

class SignIn extends StatelessWidget {
   SignIn({super.key});

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading:IconButton(onPressed: (){}, icon:Icon(Icons.person_add)),
          title: Text('Sign In'),
          elevation: 20,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Container(
              width: 300,
              height: 320,
              child: Column(
                children: [
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        hintText: "Enter your phone number",
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your password",
                        prefixIcon: Icon(Icons.password),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        signInAPI(context, onSignInSuccess: () {Navigator.push(
                            context,MaterialPageRoute(builder: (context) => HomePage()),
                          );}
                        );
                      },
                      child: Text("Sign In"),
                    ),
              
                    TextButton(onPressed: (){Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );}, child: Text("sign Up")),
                ],
              ),
            ),
          ),
        ),
        );
  }
  void signInAPI(BuildContext context,{required VoidCallback onSignInSuccess}) async {
    if(phoneController.text.isEmpty  || passwordController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("phone Number and password can't be empty")),
        );
    }
    else{
    String phoneNumber = phoneController.text.trim();
    String password = passwordController.text.trim();

    Map<String, String> data = {
      'phoneNumber': phoneNumber,
      'password': password,
    };

    Uri url = Uri.parse('http://localhost:5000/auth/signIn');
    try {
      var response = await http.post(
        url,
        body: data,
      );
      profile=response.body;
      //clientId=profile.profileId;
      if (response.statusCode == 200) {
        // Successful sign in
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign In Successful')),
        );
        onSignInSuccess();
      } else {
        // Sign in failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign In Failed')),
        );
      }
    } catch (e) {
      // Handle network errors
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network Error. Please check your connection.')),
      );
    }
  }
  }
}
//10.0.2.2