import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/userdata.dart';

class EventOnClick extends StatefulWidget {
  EventOnClick({this.ds});
  final DocumentSnapshot ds;

  @override
  _EventOnClickState createState() => _EventOnClickState();
}

class _EventOnClickState extends State<EventOnClick> {

@override
  void initState() {
    df=UserDetails().ds;
    like=df.data["likes"];
    bookmarks=df.data["bookmarks"];
    l=checkLikes();
    nlikes= widget.ds.data['likes'];
    super.initState();
  }

  int nlikes;

  DocumentSnapshot df;
    List<String> bookmarks;
    List<String> like;
    bool l;
    bool checkLikes(){
      for(int i=0;i<like.length;i++){
      if(like[i]==widget.ds.documentID)
      return true;
      }
      return false;
    }
    bool checkBookmark(){
      for(int i=0;i<bookmarks.length;i++){
      if(bookmarks[i]==widget.ds.documentID)
      return true;
      }
      return false;
    }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
   

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: 
        Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  height: height * .45,
                  width: width,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: height * .45,
                        width: width,
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            stops: [0.5,1],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent,Color(0xff000066)]
                          )
                        ),
                        child: Hero(
                          tag: "eventpic",
                          child: CachedNetworkImage(
                              imageUrl: widget.ds.data["iurl"],
                              fit: BoxFit.cover,
                            ),
                        ),
                      ),
                      Text(widget.ds.data["title"],
                          style: TextStyle(color: Colors.white, fontSize: 22))
                    ],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: height*.18,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(height*.03),bottomRight: Radius.circular(height*.03))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: width*.35,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: checkLikes()?Icon(Icons.favorite):Icon(Icons.favorite_border),
                                  color: Colors.red,
                                  onPressed: () async{
                                    if(checkLikes()){
                                      like.remove(widget.ds.documentID);
                                     await Firestore.instance.collection(UserDetails().name.split("-")[1]).document(Provider.of<FirebaseUser>(context).email).updateData({"likes":like});
                                     await  Firestore.instance.collection(UserDetails().name.split("-")[1]).document("events").collection("events").document(df.documentID).updateData({"likes":nlikes});
                                      UserDetails().reload();
                                      setState(() {
                                        l=!l;
                                        nlikes=nlikes-1;
                                      });
                                    }
                                    else{
                                      like.add(widget.ds.documentID);
                                    await  Firestore.instance.collection(UserDetails().name.split("-")[1]).document("events").collection("events").document(df.documentID).updateData({"likes":nlikes});
                                     await  Firestore.instance.collection(UserDetails().name.split("-")[1]).document(Provider.of<FirebaseUser>(context).email).updateData({"likes":like});
                                      UserDetails().reload();
                                      setState(() {
                                        l=!l;
                                        nlikes =nlikes +1;
                                      });
                                    }
                                  },
                                ),
                                Text(widget.ds.data["likes"].toString()),
                                IconButton(
                                  icon: Icon(Icons.mode_comment),
                                  onPressed: (){
                                    
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: width*.35,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.share),
                                  onPressed: (){
                                  },
                                ),
                                IconButton(icon: Icon(Icons.bookmark_border),
                                onPressed: (){

                                },)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: height*.1,
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Color(0xff000066),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(height*.04),bottomRight: Radius.circular(height*.04))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20,right: 20,left: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                           Container(
                             width: height*.07,
                             height: height*.07,
                             decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               image: DecorationImage(
                                 image: CachedNetworkImageProvider(widget.ds.data['uiurl']),
                                 fit: BoxFit.cover
                               )
                             ),
                           ),
                           Container(
                             margin: EdgeInsets.only(left: 10),
                             alignment: Alignment.bottomLeft,
                             height: height*.07,
                             width: width*.7,
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: <Widget>[
                                 Text(widget.ds.data['host'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17)),
                                 Text("${DateTime.fromMillisecondsSinceEpoch(int.parse("${widget.ds.data["utime"].toString().split("=")[1].split(",")[0]}")*1000).day.toString()}-${DateTime.fromMillisecondsSinceEpoch(int.parse("${widget.ds.data["utime"].toString().split("=")[1].split(",")[0]}")*1000).month.toString()}-${DateTime.fromMillisecondsSinceEpoch(int.parse("${widget.ds.data["utime"].toString().split("=")[1].split(",")[0]}")*1000).year.toString()}",style: TextStyle(color: Colors.white))
                               ],
                             ),
                           )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(bottom: height*.08,right: 5,left: 5),
                  child: Html(
                    defaultTextStyle: TextStyle(color: Colors.black.withOpacity(0.65),),
                    linkStyle: TextStyle(color: Colors.blue,fontStyle: FontStyle.italic),
                    data: widget.ds.data["des"],
                    renderNewlines: true,
                    onLinkTap: (value) async{
                      if(await canLaunch(value)){
                        await launch(value);
                      }
                      else{
                        Fluttertoast.showToast(
                          msg: "something went worng Can't open Url",
                          gravity: ToastGravity.BOTTOM
                        );
                      }
                    },
                  ),
                )
              ],
            ),
            Container(
              height: height,
              width: width,
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.center,
                width: width,
                height: height*.08,
                color: Colors.blue,
                child: Text("Register",style:TextStyle(color: Colors.white,fontSize:22)),
              )
            )
          ],
        ),
    );
  }
}
