import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class eventManagementsPage extends StatefulWidget {
  @override
  _EventManagementsPageState createState() => _EventManagementsPageState();
}

class _EventManagementsPageState extends State<eventManagementsPage> {
  late Stream<QuerySnapshot> _eventStream;

  @override
  void initState() {
    super.initState();
    _eventStream = FirebaseFirestore.instance.collection('events').snapshots();
  }

  void _editEvent(String eventId) {
    // Navigate to the edit event page with the eventId
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventPage(eventId: eventId),
      ),
    );
  }

  void _deleteEvent(String eventId) {
    // Delete the event from Firestore
    FirebaseFirestore.instance.collection('events').doc(eventId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Management'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _eventStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No events found.'),
            );
          }

          return ListView(
            padding: EdgeInsets.all(16),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> event = document.data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(event['eventTitle'],
                  style: TextStyle(fontSize: 12 ),
                  textAlign: TextAlign.justify,
                  ),
                  subtitle: Text(event['eventLocation'],
                  style: TextStyle(fontSize: 10)
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editEvent(document.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteEvent(document.id),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class EditEventPage extends StatefulWidget {
  final String eventId;

  EditEventPage({required this.eventId});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _facultyController;
  late TextEditingController _courseController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _facultyController = TextEditingController();
    _courseController = TextEditingController();

    // Fetch the event data from Firestore and populate the text fields
    FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        Map<String, dynamic> event = document.data() as Map<String, dynamic>;

        setState(() {
          _titleController.text = event['eventTitle'];
          _descriptionController.text = event['eventDescription'];
          _locationController.text = event['eventLocation'];
          _facultyController.text = event['faculty'];
          _courseController.text = event['course'];
        });
      }
    });
  }

  void _updateEvent() {
    // Update the event information in Firestore
    FirebaseFirestore.instance.collection('events').doc(widget.eventId).update({
      'eventTitle': _titleController.text,
      'eventDescription': _descriptionController.text,
      'eventLocation': _locationController.text,
      'faculty': _facultyController.text,
      'course': _courseController.text,
    }).then((_) {
      // Navigate back to the event management page
      Navigator.pop(context);
    }).catchError((error) {
      // Handle the update error
      print('Update event error: $error');
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _facultyController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Event Title'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 15,
              decoration: InputDecoration(labelText: 'Event Description'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Event Location'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _facultyController,
              decoration: InputDecoration(labelText: 'Faculty'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _courseController,
              decoration: InputDecoration(labelText: 'Course'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateEvent,
              child: Text('Update Event'),
            ),
          ],
        ),
      ),
    );
  }
}
