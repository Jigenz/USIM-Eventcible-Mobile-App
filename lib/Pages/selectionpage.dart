import 'package:flutter/material.dart';
import 'authentication.dart';

class SelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Role'),
        backgroundColor: Color(0xFF5C4448),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthenticationPage(role: 'Student'),
                  ),
                );
              },
              child: Text('Student'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthenticationPage(role: 'Campus Association'),
                  ),
                );
              },
              child: Text('Campus Association'),
            ),
          ],
        ),
      ),
    );
  }
}
