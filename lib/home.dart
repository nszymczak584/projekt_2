import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'presentation/list_page.dart';
import 'calendar.dart';

class HomePage extends StatelessWidget {
  final User? user;

  HomePage({required this.user});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // Navigate to sign-in or any other screen after sign-out
    } catch (e) {
      print('Failed to sign out: $e');
      // Handle sign-out errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Home Page',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListPage(user: user)),
                );
              },
              child: Text('Go to List Page'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TableEventsExample(user: user)),
                );
              },
              child: Text('Go to Calendar'),
            ),
          ],
        ),
      ),
    );
  }
}
