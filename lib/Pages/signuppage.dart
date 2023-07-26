import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usimIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();

  Future<void> signUp(BuildContext context) async {
    try {
      // Create the user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Retrieve the values from the controllers and use them to create a document for the user
      final fullName = _fullNameController.text;
      final usimId = _usimIdController.text;
      final email = _emailController.text;
      final faculty = _facultyController.text;
      final course = _courseController.text;

      // Create a document for the user in the "users" collection
      final docUser =
          FirebaseFirestore.instance.collection('users')
          .doc(userCredential.user!.uid);
      await docUser.set({
        'fullName': fullName,
        'usimId': usimId,
        'email': email,
        'faculty': faculty,
        'course': course,
        'username': _emailController.text.split('@')[0],
        
        
      });

      // Navigate to the home screen or perform any other actions
      Navigator.of(context).pushReplacementNamed("/home");
    } catch (e) {
      print(e);
      _showSnackBar(context, 'An error occurred during registration.');
    }
  }

  void _showSnackBar(BuildContext context, String errorMessage) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }




  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Color(0xFF5C4448),
      ),
      backgroundColor: Color(0xFFCBB399),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _usimIdController,
                decoration: InputDecoration(
                  labelText: 'USIM ID',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
                obscureText: true,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _facultyController,
                decoration: InputDecoration(
                  labelText: 'Faculty',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _courseController,
                decoration: InputDecoration(
                  labelText: 'Course',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => signUp(context),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF5C4448),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
