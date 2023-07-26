import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Pages/bookedEvents.dart';
import 'package:flutter_complete_guide/Pages/signuppage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './Pages/authentication.dart';
import './Pages/feedback.dart';
// Pages
import './Pages/home.dart';
import './Pages/view_all_events.dart';
import './services/auth_option2.dart';
import 'Pages/calander.dart';
import 'Pages/CreateEvents.dart';
import 'Pages/eventManagements.dart';
import 'Pages/searchEvents.dart';
import 'Pages/upcomingEvents.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: Colors.blue,
              playSound: true,
            ),
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(notification.title!),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body!)],
                ),
              ),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
        ),
        hintColor: Colors.indigo,
        fontFamily: 'Quicksand',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/auth': (context) => AuthenticationPage(),
        '/home': (context) => HomePage(),
        '/competition': (context) => upcomingEvents(),
        '/viewAllEvents': (context) => viewAllEvents(),
        '/events': (context) => CalanderScreen(),
        '/createEvents': (context) => CreateEventsPage(),
        '/bookedEvents': (context) => bookedEventsPage(),
        '/searchEvents': (context) => searchEventsPage(),
        '/eventManagements': (context) => eventManagementsPage(),
        '/feedback': (context) => feedbackPage(),
        '/signup': (ctx) => SignUpPage(),
        
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NMIMS Shirpur',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => AuthOption(),
        '/auth': (context) => AuthenticationPage(),
        '/home': (context) => HomePage(),
        '/competition': (context) => upcomingEvents(),
        '/viewAllEvents': (context) => viewAllEvents(),
        '/events': (context) =>CalanderScreen(),
        '/createEvents': (context) => CreateEventsPage(),
        '/bookedEvents': (context) => bookedEventsPage(),
        '/searchEvents': (context) => searchEventsPage(),
        '/eventManagements': (context) => eventManagementsPage(),
        '/feedback': (context) => feedbackPage(),
        '/signup': (ctx) => SignUpPage(),
      },
    );
  }
}
