import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: _height,
        margin: EdgeInsets.only(right: 10, left: 10),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  (index == 0)
                      ? Container(
                        margin: EdgeInsets.only(bottom: 20,top: 20),
                          child: Text(
                          "Notifications",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ))
                      : SizedBox(),
                  Card(
                    elevation: 15,
                    child: Container(
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(width: 6, color: Colors.blue))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: Text(
                              "Flutter Workshop",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  letterSpacing: 1.1),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 8),
                            width: _width - 60,
                            child: Text(
                              "This Workshop will gives you a quick start in flutter development",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "Monday, 17 Jan, 2019 - 3:30pm",
                            style: TextStyle(color: Colors.black45),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            height: 28,
                            width: _width - 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              itemBuilder: (context, number) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                  
                                      borderRadius: BorderRadius.circular(15)),
                                  margin: EdgeInsets.only(right: 30),
                                  child: Text(
                                    "data $number",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
