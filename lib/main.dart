import 'package:a20/utils/firebasenotifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/RootPage.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseNotifications().setUpFirebase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers: [
            StreamProvider.value(
              value: FirebaseAuth.instance.onAuthStateChanged,
            )
          ],
          child: MaterialApp(
        home: RootPage(),
      ),
    );
  }
}