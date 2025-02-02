import 'package:a20/views/drawer.dart';
import 'package:a20/views/eventspage.dart';
import 'package:flutter/material.dart';

class EventView extends StatelessWidget {

final _scaffoldKey=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideBar(n:4),
      appBar: AppBar(
        title: Text("Events",style: TextStyle(color: Colors.black.withOpacity(0.6)),),
        elevation: 0,
        backgroundColor: Colors.white,
         leading: IconButton(
          icon: Icon(Icons.menu,color:Colors.black.withOpacity(0.6)),
          onPressed: ()=>_scaffoldKey.currentState.openDrawer(),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          EventsPage(),
        ],
      )
    );
  }
}