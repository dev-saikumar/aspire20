import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height= MediaQuery.of(context).size.height;
    final double width=MediaQuery.of(context).size.width;
    return Drawer(
      child: Container(
        height: height,
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(width:width,height:height*.3),
              height: height*.3,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height*.07,),
                  CircleAvatar(
                    radius: width*.14,
                    backgroundColor: Colors.blue,
                    child: FlutterLogo(),
                  ),
                  SizedBox(height: height*.02,),
                 Column(
                   children: <Widget>[
                    Text("Saikumarredyatluri",style: TextStyle(color: Colors.black.withOpacity(0.65),fontWeight: FontWeight.w500),),
                    Text("Saikumarredyatluri@gmail.com",style: TextStyle(color: Colors.black.withOpacity(0.65)),)
                   ],
                 )
                ],
              ),
            ),
            ListTile(
              title: Text("BookMarks"),
              leading: Icon(Icons.bookmark,color:Colors.deepPurple.withOpacity(0.4)),
              trailing: Icon(Icons.arrow_right),
            ),
            ListTile(
              title: Text("Feed"),
              leading: Icon(Icons.new_releases,color:Colors.red.withOpacity(0.4)),
              trailing: Icon(Icons.arrow_right),
            ),
            ListTile(
              title: Text("Events"),
              leading: Icon(Icons.event,color:Colors.blue.withOpacity(0.4)),
              trailing: Icon(Icons.arrow_right),
            ),
            ListTile(
              title: Text("Project"),
              leading: Icon(Icons.group_work,color:Colors.brown.withOpacity(0.4)),
              trailing: Icon(Icons.arrow_right),            
            ),
            ListTile(
              title: Text("Settings"),
              leading: Icon(Icons.settings,color:Colors.cyan.withOpacity(0.2)),
              trailing: Icon(Icons.arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}