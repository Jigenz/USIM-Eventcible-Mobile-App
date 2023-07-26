import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class feedbackPage extends StatefulWidget {
  @override
  State<feedbackPage> createState() => _feedbackPageState();
}

class _feedbackPageState extends State<feedbackPage> {
  // CollectionReference feedback =
  //     FirebaseFirestore.instance.collection('feedback');
  // final formKey = GlobalKey<FormState>();
  // String FeedbackName = '';
  // String FeedbackEmail = '';
  // String FeedbackReview = '';

  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerReview = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFF0F1113),
            size: 32,
          ),
        ),
        title: Text(
          "Help & Feedback",
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Color(0xFF0F1113),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              // ignore: sized_box_for_whitespace
              Container(
                width: MediaQuery.of(context).size.width * 7 / 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Name:",
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    //name textField
                    buildFeedbackName(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Email:",
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    //email textField
                    buildFeedbackEmail(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Review:",
                      style: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    //review textField
                    buildFeedbackReview(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 7 / 8,
                height: 50.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () async {
            // write the code to add the feedback to the database
            final name = controllerName.text;
            final email = controllerEmail.text;
            final review = controllerReview.text;
            createFeedback(name: name, email: email, review: review);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Feedback Submitted'),
    ),
  );
                  
                  
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFeedbackName() => TextFormField(
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: Colors.indigo,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: Colors.indigo,
            ),
          ),
        ),
        controller: controllerName,
        validator: (value) {
          if (value!.length < 4) {
            return 'Enter at least 4 characters';
          } else {
            return null;
          }
        },
      );

  Widget buildFeedbackEmail() => TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: Colors.indigo,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: Colors.indigo,
            ),
          ),
        ),
        controller: controllerEmail,
        // ckeck if the user inputs altleast 10 chalecters
        validator: (value) {
          if (value!.length < 10) {
            return 'Enter at least 10 characters';
          } else {
            return null;
          }
        },
      );

  Widget buildFeedbackReview() => TextFormField(
        maxLines: 14,
        style: TextStyle(
          fontSize: 18,
        ),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: Colors.indigo,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: Colors.indigo,
            ),
          ),
        ),
        controller: controllerReview,
        validator: (value) {
          if (value!.length < 10) {
            return 'Enter at least 10 characters';
          } else {
            return null;
          }
        },
      );

      Future createFeedback({required String name , required String email, required String review}) async {
        final docUser= FirebaseFirestore.instance.collection('feedback').doc();

        final json ={
          'name': name,
          'email': email,
          'review': review,
        };
        await docUser.set(json);
      }
}
