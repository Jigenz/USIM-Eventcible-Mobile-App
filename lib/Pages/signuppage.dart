import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUpPage extends StatefulWidget {
  final String role; // Add the role as a parameter to the SignUpPage class

  SignUpPage({Key? key, required this.role}) : super(key: key); // Initialize the role

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? _selectedGender;
  String? _selectedCountryCode;
  DateTime? _selectedDateOfBirth;
  File? _profileImage;
  bool _passwordVisibility = false;

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
      final username = _usernameController.text;
      final email = _emailController.text;
      final gender = _selectedGender;
      final phoneNumber = _selectedCountryCode! + _phoneNumberController.text;
      final dob = _selectedDateOfBirth;
      String? profileImageUrl;

      if (_profileImage != null) {
        // Upload the profile picture to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child(userCredential.user!.uid + '.jpg');
        await storageRef.putFile(_profileImage!);
        profileImageUrl = await storageRef.getDownloadURL();
      }

      // Determine the Firestore collection based on the role
      String collection;
      if (widget.role == 'Campus Association') {
        collection = 'campus_associations';
      } else if (widget.role == 'Student') {
        collection = 'students';
      } else {
        collection = 'other';
      }

      // Create a document for the user in the appropriate collection
      final docUser = FirebaseFirestore.instance
          .collection(collection)
          .doc(userCredential.user!.uid);
      await docUser.set({
        'fullName': fullName,
        'username': username,
        'email': email,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'dob': dob,
        'profileImageUrl': profileImageUrl,
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = pickedDate;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
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
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 12),
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
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
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
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Toggle password visibility
                      setState(() {
                        _passwordVisibility = !_passwordVisibility;
                      });
                    },
                    icon: Icon(
                      _passwordVisibility
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: !_passwordVisibility,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
                items: ['Male', 'Female']
                    .map((gender) => DropdownMenuItem(
                          child: Text(gender),
                          value: gender,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  DropdownButton<String>(
                    value: _selectedCountryCode,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedCountryCode = value;
                      });
                    },
                    items: <String>['+60', '+1', '+91', '+44'] // Add more as needed
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: _selectedDateOfBirth == null
                            ? ''
                            : '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => signUp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5C4448),
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
