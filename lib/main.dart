import 'package:a20/auth/RootPage.dart';
import 'package:a20/models/userdata.dart';
import 'package:a20/utils/firebasenotifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserDetails details;
  @override
  void initState() {
    FirebaseNotifications().setUpFirebase();
    details=UserDetails();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers: [
            ChangeNotifierProvider(builder: (_)=>UserDetails()),
            StreamProvider.value(
              value: FirebaseAuth.instance.onAuthStateChanged,
            ),
          ],
          child: MaterialApp(
        home: RootPage(),
      ),
    );
  }
}