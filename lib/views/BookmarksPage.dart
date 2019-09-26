import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookMarksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BookMarks Here"),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black.withOpacity(0.5)),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection(Provider.of<FirebaseUser>(context).displayName.split("-")[1]).document(Provider.of<FirebaseUser>(context).email).snapshots(),
        builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot){
          return ListView.builder(
            itemCount: snapshot.data["bookmarks"].lenght,
            itemBuilder: (context,index){
              return Container();
            },
          );
        },
      ),
    );
  }
}