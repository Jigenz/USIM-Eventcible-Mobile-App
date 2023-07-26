import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class eventDetail extends StatefulWidget {
  final String eventId;

  eventDetail({required this.eventId, required eventImage, required eventName, required eventTime, required eventPlace, required eventDescription, required eventRegistrationLink});

  @override
  State<eventDetail> createState() => _eventDetailState();
}

class _eventDetailState extends State<eventDetail> {
  late Stream<DocumentSnapshot> _eventStream;

  @override
  void initState() {
    super.initState();
    _eventStream = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _eventStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Event Details'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Event Details'),
            ),
            body: Center(
              child: Text('Event not found.'),
            ),
          );
        }

        var eventData = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF120E16),
            automaticallyImplyLeading: false,
            leading: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.chevron_left_rounded,
                color: Color(0xFF613FE5),
                size: 32,
              ),
            ),
            title: Text(
              eventData['eventTitle'],
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [],
            centerTitle: false,
            elevation: 0,
          ),
          backgroundColor: Color(0xFF120E16),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.network(
                      eventData['eventImage'],
                      width: MediaQuery.of(context).size.width,
                      height: 230,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Event Details:',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontFamily: 'Outfit',
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          'Name: ' + eventData['eventTitle'],
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: Color(0xFFB5B5B5),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          'Time: ' + eventData['eventTime'],
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: Color(0xFFB5B5B5),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          'Venue: ' + eventData['eventPlace'],
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: Color(0xFFB5B5B5),
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          'Description: ' + eventData['eventDescription'],
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: Color(0xFFB5B5B5),
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 24),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF613FE5),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(100, 40),
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    ),
                    onPressed: () => launch(eventData['eventRegistrationLink']),
                    label: Text(
                      'Reserve Spot',
                      style: TextStyle(
                        color: Color(0xFF120E16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(
                      Icons.add,
                      color: Color(0xFF120E16),
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
