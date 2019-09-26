import 'package:a20/models/userdata.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Chat extends StatelessWidget {
  Chat({this.clgName,this.collection});
  final String clgName,collection;
  final controller = TextEditingController();
  final scrollcontroller = ScrollController();

  @override
  Widget build(BuildContext context) {

  void sendmessege() {
    if (controller.text.isNotEmpty) {
      DocumentReference df = Firestore.instance
          .collection(clgName)
          .document("comments")
          .collection(collection)
          .document(DateTime.now().millisecondsSinceEpoch.toString());
      df.setData({
        "comment": controller.text.trim(),
        "upnam": Provider.of<FirebaseUser>(context).displayName.split("-")[0],
        "turl": Provider.of<UserDetails>(context).ds.data["thumbnail"],
        "utime": DateTime.now().millisecondsSinceEpoch,
        "uid": Provider.of<FirebaseUser>(context).uid.toString()
      });
      controller.clear();
    } else {
      Fluttertoast.showToast(
          msg: "Write Something..!",
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          timeInSecForIos: 1,
          gravity: ToastGravity.BOTTOM);
    }
  }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(child: buildListview()),
                Container(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10.0)),
                        hintText: "ur message here",
                        suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.pink[500],
                                    ),
                                    onPressed: () {
                                      sendmessege();
                                      scrollcontroller.animateTo(0.0,
                                          curve: Curves.bounceOut,
                                          duration:
                                              Duration(milliseconds: 400));
                                    })
                        ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListview() {
    var cf = Firestore.instance
        .collection(clgName)
        .document("comments")
        .collection(collection)
        .reference();
    return StreamBuilder<QuerySnapshot>(
      stream: cf.orderBy('utime', descending: true).limit(10).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text("went on error"),
              );
            } else {
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: scrollcontroller,
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) =>
                  buildmesseges(index, snapshot.data.documents[index]));
            }
        }
      },
    );
  }

  Widget buildmesseges(int n, DocumentSnapshot snapshot) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      alignment: Alignment.topCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 50,
            width: 50,
            margin: EdgeInsets.only(top: 5,left: 5,right: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
              image: DecorationImage(image: CachedNetworkImageProvider(snapshot.data["turl"]),fit: BoxFit.cover)
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Text(snapshot.data["upnam"],style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,fontSize: 16),),
            ),
            Text(snapshot.data["comment"],style: TextStyle(color: Colors.black54),)
            ],
          )
        ],
      ),
    );
  }


}