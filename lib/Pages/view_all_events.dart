import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Pages/eventDetails.dart';

class viewAllEvents extends StatefulWidget {
  const viewAllEvents({super.key});

  @override
  State<viewAllEvents> createState() => _viewAllEventsState();
}

class _viewAllEventsState extends State<viewAllEvents> {
  List<String> _imageUrls = [];
  List<String> _eventNames = [];
  List<String> _eventTime = [];
  List<String> _eventPlace = [];
  List<String> _eventDescription = [];
  List<String> _eventRegistrationLink = [];

  @override
  void initState() {
    super.initState();
    _getImageUrls();
  }

  void _getImageUrls() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    List<String> urls = [];
    List<String> eventNames = [];
    List<String> eventTimes = [];
    List<String> eventPlaces = [];
    List<String> eventDescriptions = [];
    List<String> eventRegistrationLinks = [];
    snapshot.docs.forEach((doc) {
      var data = doc.data();
      if (data != null && data is Map<String, dynamic>) {
        var imagePath = data['imagePath'];
        var eventName = data['eventName'];
        var eventTime = data['eventTime'];
        var eventPlace = data['eventPlace'];
        var eventDescription = data['shortDescription'];
        var eventRegistrationLink = data['registrationLink'];
        if (imagePath != null &&
            eventName != null &&
            eventTime != null &&
            eventPlace != null &&
            eventDescription != null &&
            eventRegistrationLink != null) {
          urls.add(imagePath);
          eventNames.add(eventName);
          eventTimes.add(eventTime);
          eventPlaces.add(eventPlace);
          eventDescriptions.add(eventDescription);
          eventRegistrationLinks.add(eventRegistrationLink);
        }
      }
    });
    setState(() {
      _imageUrls = urls;
      _eventNames = eventNames;
      _eventTime = eventTimes;
      _eventPlace = eventPlaces;
      _eventDescription = eventDescriptions;
      _eventRegistrationLink = eventRegistrationLinks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.orange),
        iconTheme: IconThemeData(color: Color(0xFF613FE5),
),
        backgroundColor: Color(0xFF120E16),

        title: Text(
          'Events',
          style: TextStyle(
            fontFamily: 'Lexend Deca',
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
        elevation: 0,
      ),
      backgroundColor: Color(0xFF120E16),

      body: ListView.builder(
        itemCount: _imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 20),
            child: Container(
              width: double.infinity,
              height: 184,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: NetworkImage(_imageUrls[index]),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Color(0x33000000),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0x65090F13),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                _eventNames[index],
                                style: TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(16, 4, 16, 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 4),
                                      child: Text(
                                        _eventTime[index],
                                        style: TextStyle(
                                          fontFamily: 'Lexend Deca',
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _eventPlace[index],
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontFamily: 'Lexend Deca',
                                        color: Color(0xB4FFFFFF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color(0xFF613FE5),
)),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    eventDetail(
                                                      eventName:
                                                          _eventNames[index],
                                                      eventTime:
                                                          _eventTime[index],
                                                      eventPlace:
                                                          _eventPlace[index],
                                                      eventDescription:
                                                          _eventDescription[
                                                              index],
                                                      eventImage:
                                                          _imageUrls[index],
                                                      eventRegistrationLink:
                                                          _eventRegistrationLink[
                                                              index], eventId: '',
                                                    )),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                        ),
                                        label: Text(('Know More')))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
