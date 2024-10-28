import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AuthenticationPage extends StatefulWidget {
  final String role;

  const AuthenticationPage({Key? key, required this.role}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool _isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _usimIdController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usimIdController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.of(context).pushReplacementNamed("/home");
    } catch (error) {
      String errorMessage = 'Authentication failed';
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          errorMessage = 'No user found for that USIM EMAIL.';
        } else if (error.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that USIM EMAIL.';
        }
      }
      final snackBar = SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _usimIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSignInDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5C4448),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _usimIdController,
                    decoration: InputDecoration(
                      labelText: 'USIM EMAIL',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: Color(0xFF5C4448),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: Color(0xFF5C4448),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          signIn();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFCBB399),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Color(0xFF5C4448),
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Sign In';
    String signInLabel = 'Sign in with USIM EMAIL';
    if (widget.role == 'Campus Association') {
      title = 'Campus Association Sign In';
      signInLabel = 'Sign in for Association';
    } else if (widget.role == 'Student') {
      title = 'Student Sign In';
      signInLabel = 'Sign in for Student';
    } else if (widget.role == 'OtherRole') {
      // Customize for other roles
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFCBB399)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'Welcome To',
              textAlign: TextAlign.center,
              style: GoogleFonts.bebasNeue(
                fontSize: 24,
                color: Color(0xFFCBB399),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'USIM EVENTCIBLE!',
              textAlign: TextAlign.center,
              style: GoogleFonts.bebasNeue(
                fontSize: 28,
                color: Color(0xFFCBB399),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),

      backgroundColor: Color(0xFF5C4448),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 500,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF5C4448),
                        Color(0xFFCBB399),
                      ],
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        child: LottieBuilder.asset(
                          'Assets/129732-walk-cycle-la-communaute.json',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFCBB399),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      textStyle: TextStyle(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: _isLoading ? null : _showSignInDialog,
                    label: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            signInLabel,
                            style: TextStyle(
                              color: Color(0xFF5C4448),
                            ),
                          ),
                                              icon: Icon(Icons.login, color: Color(0xFF5C4448)),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/signup", arguments: widget.role);
                },
                child: Text(
                  'Sign up',
                  style: TextStyle(
                    color: Color(0xFFCBB399),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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

