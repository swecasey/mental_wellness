import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in/pages/signIn.dart';

class SignUp extends StatelessWidget {
   SignUp({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading:IconButton(onPressed: (){}, icon:Icon(Icons.person_add)),
          title: Text('Sign Up'),
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
                      controller: nameController,                
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Name",
                        hintText: "Enter your name",
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
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
                    TextButton(onPressed: () {
                    signUpAPI(context, onSignUpSuccess: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    });
                  }, child: Text("sign Up")),
                    TextButton(onPressed: (){Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );}, child: Text("sign In")),
                ],
              ),
            ),
          ),
        ),
        );
  }
  void signUpAPI(BuildContext context,{required VoidCallback onSignUpSuccess})async{
    if(phoneController.text.isEmpty  || passwordController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("phone Number and password can't be empty")),
        );
    }
    else{
    String name = nameController.text.trim();
    String phoneNumber = phoneController.text.trim();
    String password = passwordController.text.trim();

    Map<String, String> data = {
      'name': name,
      'phoneNumber': phoneNumber,
      'password': password,
    };
    Uri url = Uri.parse("http://localhost:5000/auth/signUp");
    try {
      var response = await http.post(
        url,
        body: data,
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign Up Successful')),
        );
      onSignUpSuccess(); 
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign Up Failed')),
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