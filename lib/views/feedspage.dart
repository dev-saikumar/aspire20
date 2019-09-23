import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Feeds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("biher")
            .document("feeds")
            .collection("feeds")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData)
            return Column(
              children: <Widget>[
                for (int i = 0; i < snapshot.data.documents.length; i++)
                  InkWell(
                    onTap: () {},
                    child: Card(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                height: height * .30,
                                width: width,
                                foregroundDecoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.5),
                                          Colors.black.withOpacity(0.5)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [.5, 1])),
                                child: Hero(
                                  tag: "eventpic",
                                  child: CachedNetworkImage(
                                      imageUrl: snapshot.data.documents[i]
                                          ["iurl"],
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                height: height * .09,
                                padding: EdgeInsets.only(left: 5, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      Container(
                                        height: height * .06,
                                        width: height * .06,
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image:
                                                    CachedNetworkImageProvider(
                                                        snapshot.data
                                                                .documents[i]
                                                            ["uiurl"]))),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        height: height * .07,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data.documents[i]
                                                  ["unam"],
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                                "${DateTime.fromMillisecondsSinceEpoch(int.parse("${snapshot.data.documents[0]["udat"].toString().split("=")[1].split(",")[0]}") * 1000).day.toString()}-${DateTime.fromMillisecondsSinceEpoch(int.parse("${snapshot.data.documents[0]["udat"].toString().split("=")[1].split(",")[0]}") * 1000).month.toString()}-${DateTime.fromMillisecondsSinceEpoch(int.parse("${snapshot.data.documents[0]["udat"].toString().split("=")[1].split(",")[0]}") * 1000).year.toString()}",
                                                style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontWeight:
                                                        FontWeight.w400))
                                          ],
                                        ),
                                      ),
                                    ]),
                                    SizedBox(
                                      height: height * .05,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${snapshot.data.documents[i]["tags"][1]}",
                                            style: TextStyle(
                                                color: Colors.blueGrey
                                                    .withOpacity(0.8)),
                                          )),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: height * .30,
                            width: width,
                            child: Text(
                              snapshot.data.documents[i]["topic"],
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 40),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            );
        });
  }
}
