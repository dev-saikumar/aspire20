import 'package:a20/views/ProjectView.dart';
import 'package:a20/views/eventView.dart';
import 'package:a20/views/feedView.dart';
import 'package:a20/views/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  SideBar({this.n});
  final int n;
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
            Container(
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: n==1?CupertinoColors.activeBlue.withOpacity(0.6):Colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(100),topRight: Radius.circular(100))
              ),
              child: ListTile(
                title: Text("Home"),
                leading: Icon(Icons.home,color:Colors.deepPurple.withOpacity(0.2)),
                trailing: Icon(Icons.arrow_right),
                onTap: (){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));}
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: n==2?CupertinoColors.activeBlue.withOpacity(0.6):Colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(100),topRight: Radius.circular(100))
              ),
              child: ListTile(
                title: Text("BookMarks"),
                leading: Icon(Icons.bookmark,color:Colors.deepPurple.withOpacity(0.2)),
                trailing: Icon(Icons.arrow_right),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: n==3?CupertinoColors.activeBlue.withOpacity(0.6):Colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(100),topRight: Radius.circular(100))
              ),
              child: ListTile(
                title: Text("Feed"),
                leading: Icon(Icons.new_releases,color:Colors.red.withOpacity(0.2)),
                trailing: Icon(Icons.arrow_right),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=> FeedView()));
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: n==4?CupertinoColors.activeBlue.withOpacity(0.6):Colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(100),topRight: Radius.circular(100))
              ),
              child: ListTile(
                title: Text("Events"),
                leading: Icon(Icons.event,color:Colors.blue.withOpacity(0.2)),
                trailing: Icon(Icons.arrow_right),
                 onTap: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=> EventView()));
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: n==5?CupertinoColors.activeBlue.withOpacity(0.6):Colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(100),topRight: Radius.circular(100))
              ),
              child: ListTile(
                title: Text("Project"),
                leading: Icon(Icons.group_work,color:Colors.brown.withOpacity(0.2)),
                trailing: Icon(Icons.arrow_right), 
                 onTap: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=> ProjectView()));
                },           
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: n==6?CupertinoColors.activeBlue.withOpacity(0.2):Colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(100),topRight: Radius.circular(100))
              ),
              child: ListTile(
                title: Text("Settings"),
                leading: Icon(Icons.settings,color:Colors.cyan.withOpacity(0.2)),
                trailing: Icon(Icons.arrow_right),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: n==7?CupertinoColors.activeBlue.withOpacity(0.6):Colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(100),topRight: Radius.circular(100))
              ),
              child: ListTile(
                title: Text("SignOut"),
                leading: Icon(Icons.exit_to_app,color:Colors.indigo.withOpacity(0.4)),
                onTap: (){
                  FirebaseAuth.instance.signOut();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}