import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Pages/eventDetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class CalanderScreen extends StatefulWidget {
  @override
  _CalanderScreenState createState() => _CalanderScreenState();
}

class _CalanderScreenState extends State<CalanderScreen> {
  Future<List<Map<String, dynamic>>> getEventList() async {
    final CollectionReference eventsCollection =
        FirebaseFirestore.instance.collection('users');

    // Get events data from Firestore
    final QuerySnapshot snapshot = await eventsCollection.get();
    final List<DocumentSnapshot> events = snapshot.docs;

    // Create a list to store the events
    final List<Map<String, dynamic>> eventList = [];

    // Convert Firestore timestamps to DateTime objects
    for (var event in events) {
      final Map<String, dynamic> data =
          event.data() as Map<String, dynamic>;
      if (data != null) {
        final Timestamp startTimestamp = data['eventDate'];
        final DateTime start = startTimestamp.toDate();
        var imagePath = data['imagePath'];
        var eventName = data['eventName'];
        var eventTime = data['eventTime'];
        var eventPlace = data['eventPlace'];
        var eventDescription = data['shortDescription'];
        var eventRegistrationLink = data['registrationLink'];
        eventList.add({
          "start": start,
          "imagePath": imagePath,
          "eventName": eventName,
          "eventTime": eventTime,
          "eventPlace": eventPlace,
          "eventDescription": eventDescription,
          "eventRegistrationLink": eventRegistrationLink,
        });
      }
    }
    return eventList;
  }

  List<Map<String, dynamic>> eventList = [];

  @override
  void initState() {
    super.initState();
    getEventList().then((list) {
      setState(() {
        eventList = list;
      });
    });
  }

  List<Map<String, dynamic>> _selectedEvents = [];
  void _onDateSelected(DateTime date, DateTime enddate) {
    setState(() {
      _selectedEvents = eventList
          .where((event) =>
              event['start'].day == date.day &&
              event['start'].month == date.month &&
              event['start'].year == date.year)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF120E16),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TableCalendar(
                  daysOfWeekHeight: 20,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    weekendStyle: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  rowHeight: 40,
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFF613FE5),
                      shape: BoxShape.circle,
                    ),
                    outsideDaysVisible: false,
                  ),
                  pageAnimationCurve: Curves.easeInOut,
                  calendarFormat: CalendarFormat.month,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    leftChevronIcon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    rightChevronIcon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                  currentDay: DateTime.now(),
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  enabledDayPredicate: (day) {
                    return eventList
                        .where((event) =>
                            event['start'].day == day.day &&
                            event['start'].month == day.month &&
                            event['start'].year == day.year)
                        .toList()
                        .isNotEmpty;
                  },
                  onDaySelected: _onDateSelected,
                  selectedDayPredicate: (day) {
                    return true;
                  },
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _selectedEvents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => eventDetail(
                              eventImage: _selectedEvents[index]['imagePath'],
                              eventName: _selectedEvents[index]['eventName'],
                              eventTime: _selectedEvents[index]['eventTime'],
                              eventPlace: _selectedEvents[index]['eventPlace'],
                              eventDescription: _selectedEvents[index]
                                  ['eventDescription'],
                              eventRegistrationLink: _selectedEvents[index]
                                  ['eventRegistrationLink'],
                              eventId: '',
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xFF613FE5),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x230E151B),
                                offset: Offset(0, 2),
                              )
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(0),
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(0),
                                ),
                                child: Image.network(
                                  _selectedEvents[index]['imagePath'],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12, 0, 12, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedEvents[index]['eventName'],
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        color: Color(0xFFF6F6F7),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 4, 0, 4),
                                      child: Text(
                                        _selectedEvents[index]['eventTime'],
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          fontFamily: 'Poppins',
                                          color: Color(0xFFF6F6F7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      _selectedEvents[index]['eventPlace'],
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Color(0xFFF6F6F7),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
