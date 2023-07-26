import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class upcomingEvents extends StatefulWidget {
  @override
  _UpcomingEventsPageState createState() => _UpcomingEventsPageState();
}

class _UpcomingEventsPageState extends State<upcomingEvents> {
  final TextEditingController _bookingController = TextEditingController();

  void _showBookingDialog(DocumentSnapshot event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event['eventTitle'] ?? ''),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['eventDescription'] ?? '',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _bookingController,
                  decoration: InputDecoration(labelText: 'Booking Details'),
                ),
              ],
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
                _bookEvent(event);
                Navigator.of(context).pop();
              },
              child: Text(
                'Book',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

void _bookEvent(DocumentSnapshot event) async {
  String bookingDetails = _bookingController.text;
  String eventId = event.id;

  try {
    await FirebaseFirestore.instance.collection('bookings').add({
      'eventId': eventId,
      'bookingDetails': bookingDetails,
    });

    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Event Booked'),
          content: Text('You have successfully booked the event.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  } catch (error) {
    // Show an error dialog if the booking failed
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Failed'),
          content: Text('An error occurred while booking the event. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Events'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot event = snapshot.data!.docs[index];
                  return EventCard(event: event, onBook: _showBookingDialog);
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final DocumentSnapshot event;
  final Function(DocumentSnapshot) onBook;

  const EventCard({required this.event, required this.onBook});

  @override
  Widget build(BuildContext context) {
    String? imageUrl = event['eventImage'];
    String? eventTitle = event['eventTitle'];
    String? eventLocation = event['eventLocation'];

    return Card(
      child: Column(
        children: [
          if (imageUrl != null)
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ListTile(
            title: Text(eventTitle ?? ''),
            subtitle: Text(eventLocation ?? ''),
            onTap: () {
              onBook(event);
            },
          ),
        ],
      ),
    );
  }
}
