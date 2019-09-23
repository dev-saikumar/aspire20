import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './eventsClickPage.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("biher").document("events").collection("events").snapshots(),
      builder: (context, snapshot) {

        if(snapshot.hasData){
        return 
          Column(
            children: <Widget>[
                      for(int i=0;i<snapshot.data.documents.length;i++)
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => EventOnClick(ds: snapshot.data.documents[i],)));
                },
                child: Card(
                  margin: EdgeInsets.only(
                      left: width * .06, right: width * .06, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Hero(
                        tag: "eventpic",
                        child: Container(
                            height: height * .35,
                            width: width * .8,
                            child: CachedNetworkImage(
                              height: height * .35,
                              width: width * .8,
                              imageUrl:
                                  snapshot.data.documents[i]["iurl"],
                              fit: BoxFit.fill,
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          snapshot.data.documents[i]['title'],
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            margin: EdgeInsets.only(left: 10, bottom: 10),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.orange.withOpacity(0.7),
                                ),
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 10, bottom: 10),
                                child: Column(
                                  children: <Widget>[
                                    Text(DateTime.fromMillisecondsSinceEpoch(int.parse("${snapshot.data.documents[0]["time"].toString().split("=")[1].split(",")[0]}")*1000).day.toString()
                                  ,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 17),
                                    ),
                                    Text(DateTime.fromMillisecondsSinceEpoch(int.parse("${snapshot.data.documents[0]["time"].toString().split("=")[1].split(",")[0]}")*1000).month.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16))
                                  ],
                                )),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  snapshot.data.documents[i]["venue"],
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      TextStyle(color: Colors.black.withOpacity(0.6)),
                                ),
                                Text(
                              "${DateTime.fromMillisecondsSinceEpoch(int.parse("${snapshot.data.documents[0]["time"].toString().split("=")[1].split(",")[0]}")*1000).day.toString()}-${DateTime.fromMillisecondsSinceEpoch(int.parse("${snapshot.data.documents[0]["time"].toString().split("=")[1].split(",")[0]}")*1000).month.toString()}-${DateTime.fromMillisecondsSinceEpoch(int.parse("${snapshot.data.documents[0]["time"].toString().split("=")[1].split(",")[0]}")*1000).year.toString()}",
                                  style:
                                      TextStyle(color: Colors.black.withOpacity(0.6)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
        ),
            ],
          );
      }
      
      }
    );
  }
}
