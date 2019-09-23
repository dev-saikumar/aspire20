import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './views/homescreen.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers: [
            StreamProvider.value(
              value: FirebaseAuth.instance.onAuthStateChanged,
            )
          ],
          child: MaterialApp(
        home: HomeScreen(clgname: "BIHER",),
      ),
    );
  }
}