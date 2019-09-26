import 'package:a20/views/drawer.dart';
import 'package:a20/views/projectspage.dart';
import 'package:flutter/material.dart';

class ProjectView extends StatelessWidget {

  final _scaffoldKey=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideBar(n:5),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu,color:Colors.black.withOpacity(0.6)),
          onPressed: ()=>_scaffoldKey.currentState.openDrawer(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Projects",style:TextStyle(color: Colors.black.withOpacity(0.6))),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          ProjectsPage(),
        ],
      )
    );
  }
}