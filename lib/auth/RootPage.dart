import 'package:a20/views/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'login.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider.of<FirebaseUser>(context) == null
        ? Login()
        : HomeScreen();
  }
}
