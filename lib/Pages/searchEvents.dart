import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class searchEventsPage extends StatefulWidget {
  @override
  _SearchEventsState createState() => _SearchEventsState();
}

class _SearchEventsState extends State<searchEventsPage> {
  late TextEditingController _searchController;
  String _searchKeyword = '';
  String _selectedFaculty = '';
  String _selectedCourse = '';

  List<String> _facultyOptions = [];
  List<String> _courseOptions = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchEventOptions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchEventOptions() async {
    // Fetch event data from Firestore
    final eventsSnapshot = await FirebaseFirestore.instance.collection('events').get();
    final events = eventsSnapshot.docs;

    // Get unique faculties and courses
    final Set<String> facultiesSet = Set();
    final Set<String> coursesSet = Set();
    events.forEach((event) {
      facultiesSet.add(event['faculty']);
      coursesSet.add(event['course']);
    });

    setState(() {
      _facultyOptions = facultiesSet.toList();
      _courseOptions = coursesSet.toList();
    });
  }

  void _onSearchSubmitted(String? keyword) {
    if (keyword != null) {
      setState(() {
        _searchKeyword = keyword.trim();
        _selectedFaculty = '';
        _selectedCourse = '';
      });
    }
  }

  void _onFacultyChanged(String? faculty) {
    if (faculty != null) {
      setState(() {
        _selectedFaculty = faculty;
        _searchKeyword = '';
        _searchController.clear();
      });
    }
  }

  void _onCourseChanged(String? course) {
    if (course != null) {
      setState(() {
        _selectedCourse = course;
        _searchKeyword = '';
        _searchController.clear();
      });
    }
  }

  void _showEventDetails(DocumentSnapshot event) {
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
                ElevatedButton(
                  onPressed: () {
                    _bookEvent(event);
                    Navigator.of(context).pop();
                  },
                  child: Text('Book Event'),
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
                'Close',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _bookEvent(DocumentSnapshot event) {
    // Handle booking logic here
    // ...
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Events'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _onSearchSubmitted(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Faculty:'),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedFaculty.isNotEmpty ? _selectedFaculty : null,
                  items: _facultyOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: _onFacultyChanged,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Course:'),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedCourse.isNotEmpty ? _selectedCourse : null,
                  items: _courseOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: _onCourseChanged,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('events').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final events = snapshot.data!.docs;
                  List<DocumentSnapshot> filteredEvents = events;
                  if (_searchKeyword.isNotEmpty) {
                    filteredEvents = events.where((event) {
                      final title = event['eventTitle'].toString().toLowerCase();
                      return title.contains(_searchKeyword.toLowerCase());
                    }).toList();
                  } else if (_selectedFaculty.isNotEmpty) {
                    filteredEvents = events.where((event) {
                      final faculty = event['faculty'];
                      return faculty == _selectedFaculty;
                    }).toList();
                  } else if (_selectedCourse.isNotEmpty) {
                    filteredEvents = events.where((event) {
                      final course = event['course'];
                      return course == _selectedCourse;
                    }).toList();
                  }

                  return ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (BuildContext context, int index) {
                      final event = filteredEvents[index];
                      final imageUrl = event['eventImage'];
                      final title = event['eventTitle'];
                      final location = event['eventLocation'];

                      return Card(
                        child: ListTile(
                          leading: imageUrl != null ? Image.network(imageUrl) : null,
                          title: Text(title ?? ''),
                          subtitle: Text(location ?? ''),
                          onTap: () {
                            _showEventDetails(event);
                          },
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
