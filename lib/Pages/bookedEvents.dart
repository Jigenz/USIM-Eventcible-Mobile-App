import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class bookedEventsPage extends StatefulWidget {
  @override
  _BookedEventsState createState() => _BookedEventsState();
}

class _BookedEventsState extends State<bookedEventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booked Events'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final bookings = snapshot.data!.docs;
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (BuildContext context, int index) {
                  final booking = bookings[index];
                  final eventId = booking['eventId'];

                  return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('events').doc(eventId).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> eventSnapshot) {
                      if (eventSnapshot.hasData) {
                        final event = eventSnapshot.data!;
                        final eventTitle = event['eventTitle'];
                        final eventLocation = event['eventLocation'];
                        final eventImage = event['eventImage'];

                        final eventDate = DateFormat('dd MMMM').format((event['eventDate'] as Timestamp).toDate());

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(eventImage ?? ''),
                            ),
                            title: Text(eventTitle ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10),),
                            subtitle: Text(eventDate,
                            style: TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                            
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteBooking(booking.id);
                              },
                            ),
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  );
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

  void _deleteBooking(String bookingId) {
    FirebaseFirestore.instance.collection('bookings').doc(bookingId).delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Booking deleted successfully.'),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete booking.'),
      ));
    });
  }
}
