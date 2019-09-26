import 'package:a20/models/likesmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:a20/models/userdata.dart';
import 'chat.dart';

class EventOnClick extends StatefulWidget {
  EventOnClick({this.ds});

  final DocumentSnapshot ds;

  @override
  _EventOnClickState createState() => _EventOnClickState();
}

class _EventOnClickState extends State<EventOnClick> {
  @override
  Widget build(BuildContext context) {
        var like= new List<dynamic>.from(Provider.of<UserDetails>(context).ds.data["elikes"]);
        var bookmarks=List<dynamic>.from(Provider.of<UserDetails>(context).ds.data["bookmarks"]);

 final scaffoldKey=GlobalKey<ScaffoldState>();
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

    showBottomSheet(clgName,collection,height,width) async{
      scaffoldKey.currentState.showBottomSheet<void>(( BuildContext context)=>
        Container(
          height: height*.8,
          width: width,
          child: Chat(clgName: clgName,collection: collection,),
        )
      );
    }

    String clgName=Provider.of<FirebaseUser>(context).displayName.split("-")[1];

    


    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness: Brightness.dark));  
    return ChangeNotifierProvider(
      builder: (context) =>Liker(li: checkLikes(),count:widget.ds.data['likes'],bk: checkBookmark()),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          key:scaffoldKey,
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
                          Align(
                            alignment: Alignment.center,
                            child: Text(widget.ds.data["title"],
                                style: TextStyle(color: Colors.white, fontSize: 30)),
                          )
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
                          child: Consumer<Liker>(
                            builder: (context,liker, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                           IconButton(
                                                icon: liker.li?Icon(Icons.favorite):Icon(Icons.favorite_border),
                                                color: Colors.red,
                                                onPressed: (){
                                                  Provider.of<Liker>(context).toogle();
                                                  if(!liker.li){
                                                    like.remove(widget.ds.documentID);
                                                  Firestore.instance.collection(Provider.of<FirebaseUser>(context).displayName.split("-")[1]).document(Provider.of<FirebaseUser>(context).email).updateData({"elikes":like}).then((_){});
                                                  Firestore.instance.collection(Provider.of<FirebaseUser>(context).displayName.split("-")[1]).document("events").collection("events").document(widget.ds.documentID).updateData({"likes":liker.count}).then((_){});
                                                   Provider.of<UserDetails>(context).reload();
                                                  }else{
                                                    like.insert(like.length,widget.ds.documentID);
                                                  Firestore.instance.collection(Provider.of<FirebaseUser>(context).displayName.split("-")[1]).document("events").collection("events").document(widget.ds.documentID).updateData({"likes":liker.count}).then((_){});
                                                  Firestore.instance.collection(Provider.of<FirebaseUser>(context).displayName.split("-")[1]).document(Provider.of<FirebaseUser>(context).email).updateData({"elikes":like}).then((_){});
                                                    Provider.of<UserDetails>(context).reload();
                                                  }
                                            }
                                          ),
                                          Text(Provider.of<Liker>(context).count.toString()),
                                          IconButton(
                                            icon: Icon(Icons.mode_comment),
                                            onPressed: ()async{
                                              showBottomSheet(clgName,widget.ds.documentID,height,width);
                                            }
                                          ),
                                          IconButton(
                                          icon: Icon(Icons.share),
                                          onPressed: (){
                                          },
                                        ),
                                        IconButton(icon: Provider.of<Liker>(context).bk?Icon(Icons.bookmark):Icon(Icons.bookmark_border),
                                        onPressed: (){
                                          Provider.of<Liker>(context).marktoogle();
                                          if(!Provider.of<Liker>(context).bk){
                                            bookmarks.remove(widget.ds.documentID);
                                            Firestore.instance.collection(Provider.of<FirebaseUser>(context).displayName.split("-")[1]).document(Provider.of<FirebaseUser>(context).email).updateData({"bookmarks":bookmarks}).then((_){});
                                            Provider.of<UserDetails>(context).reload();
                                          }
                                          else{
                                            bookmarks.insert(bookmarks.length,widget.ds.documentID);
                                            Firestore.instance.collection(Provider.of<FirebaseUser>(context).displayName.split("-")[1]).document(Provider.of<FirebaseUser>(context).email).updateData({"bookmarks":bookmarks}).then((_){});
                                            Provider.of<UserDetails>(context).reload();
                                          }
                                        },)
                                        ],
                                      );
                            }
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
        )
    );
  }
}
