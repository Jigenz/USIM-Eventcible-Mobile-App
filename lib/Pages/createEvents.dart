import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:path/path.dart' as Path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Events',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
           primary: Color(0xFF5C4448),
      
        )
      ),
      home: CreateEventsPage(),
    );
  }
}

class CreateEventsPage extends StatefulWidget {
  @override
  _CreateEventsPageState createState() => _CreateEventsPageState();
}

class _CreateEventsPageState extends State<CreateEventsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String? associateCredential;
  String? position;
  File? eventImageFile;
  String? eventTitle;
  String? eventDescription;
  DateTime? eventDate;
  String? eventLocation;
  String? faculty;
  String? course;
  String? eventId; // Added 'eventId' field

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _credentialFirestore = FirebaseFirestore.instance;
  final FirebaseFirestore _eventFirestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _openCredentialDialog(context);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _openCredentialDialog(BuildContext context) {
    _animationController.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Associate Credential and Position'),
          content: Container(
            color: Colors.white,
            child: SizedBox(
              height: 200,
              child: ListView(
                children: [
                  TextField(
                    onChanged: (value) {
                      associateCredential = value;
                    },
                    decoration: InputDecoration(labelText: 'Associate Credential'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      position = value;
                    },
                    decoration: InputDecoration(labelText: 'Position'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                _submitCredentials();
                Navigator.of(context).pop();
                _showCredentialConfirmationDialog(context);
              },
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _submitCredentials() async {
    if (associateCredential != null && position != null) {
      try {
        await _credentialFirestore.collection('credentials').add({
          'associateCredential': associateCredential,
          'position': position,
        });
      } catch (e) {
        // Handle credential submission error
        print('Credential submission error: $e');
      }
    }
  }

  Future<void> _pickEventImage() async {
    final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        eventImageFile = File(pickedImage.path);
      });
    }
  }

  void _createEvent() async {
  if (eventImageFile != null &&
      eventTitle != null &&
      eventDescription != null &&
      eventDate != null &&
      eventLocation != null &&
      faculty != null &&
      course != null) {
    try {
      // Upload event image to Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child('event_images/${Path.basename(eventImageFile!.path)}');
      UploadTask uploadTask = storageReference.putFile(eventImageFile!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Create event document in Firestore
      DocumentReference eventRef = await _eventFirestore.collection('events').add({
        'eventImage': imageUrl,
        'eventTitle': eventTitle,
        'eventDescription': eventDescription,
        'eventDate': eventDate,
        'eventLocation': eventLocation,
        'faculty': faculty,
        'course': course,
      });
      setState(() {
        eventId = eventRef.id;
      });

      _showEventCreationConfirmationDialog(context);
    } catch (e) {
      // Handle event creation error
      print('Event creation error: $e');
    }
  }
}


  void _showCredentialConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Credential Submitted'),
          content: Text('Your credential request has been accepted successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Color(0xFF5C4448)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEventCreationConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Event Created'),
          content: Text('Event created successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Color(0xFF5C4448)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Events'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 16),
                    if (_auth.currentUser != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Please fill in the event details:',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 8),
                          // Add your form fields and other UI elements here
                          GestureDetector(
                            onTap: _pickEventImage,
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              color: Colors.grey[200],
                              child: eventImageFile != null
                                  ? Image.file(eventImageFile!)
                                  : Icon(Icons.image, size: 50),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            onChanged: (value) {
                              eventTitle = value;
                            },
                            decoration: InputDecoration(labelText: 'Event Title'),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            maxLines: 8,
                            onChanged: (value) {
                              eventDescription = value;
                            },
                            decoration: InputDecoration(labelText: 'Event Description'),
                          ),
                          SizedBox(height: 8),
                          TableCalendar(
                            firstDay: DateTime.now(),
                            lastDay: DateTime.now().add(Duration(days: 365)),
                            focusedDay: DateTime.now(),
                            calendarFormat: CalendarFormat.month,
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleTextStyle: TextStyle(fontSize: 20),
                              leftChevronIcon: Icon(Icons.chevron_left),
                              rightChevronIcon: Icon(Icons.chevron_right),
                            ),
                            calendarStyle: CalendarStyle(
                              todayDecoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            selectedDayPredicate: (day) {
                              return eventDate == day;
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                eventDate = selectedDay;
                              });
                            },
                          ),
                          SizedBox(height: 8),
                          TextField(
                            onChanged: (value) {
                              eventLocation = value;
                            },
                            decoration: InputDecoration(labelText: 'Event Location'),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            onChanged: (value) {
                              faculty = value;
                            },
                            decoration: InputDecoration(labelText: 'Faculty'),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            onChanged: (value) {
                              course = value;
                            },
                            decoration: InputDecoration(labelText: 'Course'),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _createEvent,
                            child: Text('Create Event'),
                          ),
                        ],
                      ),
                    if (_auth.currentUser == null)
                      Text(
                        'You must be logged in to create events.',
                        style: TextStyle(fontSize: 20),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
