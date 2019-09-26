import 'package:flutter/material.dart';

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  Widget build(BuildContext context) {
    final bool selected=true;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RawChip(
              backgroundColor: selected?Colors.blue.withOpacity(0.3):Colors.white,
              label: Text("My Projects"),
              shape: RoundedRectangleBorder(side: BorderSide(color: selected?Colors.white:Colors.black.withOpacity(0.6)),borderRadius: BorderRadius.circular(250)),
            ),
            RawChip(
              backgroundColor: !selected?Colors.red.withOpacity(0.3):Colors.white,
              label: Text("All Projects"),
              shape: RoundedRectangleBorder(side: BorderSide(color: !selected?Colors.white:Colors.black.withOpacity(0.6)),borderRadius: BorderRadius.circular(250)),
            )
          ],
        ),
        SizedBox(height: 5,),
        MyProjects()
      ],
    );
  }
}

class MyProjects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height=MediaQuery.of(context).size.height;
    final double width=MediaQuery.of(context).size.width;
    int i=1;
    
    return Column(
      children: <Widget>[
        for(i=1;i<5;i++)
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
                      margin:EdgeInsets.only(left: 10,right: 10,bottom: 15),

                  child: Container(
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15)
            ),
            height: height*.20,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 3,color: Color(0xff000066),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 3,top: 5),
                      height: 25,
                  width: width*.8,
                      child: Text("Flutter",overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black.withOpacity(0.7),fontWeight: FontWeight.w500,fontSize: 27),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 3,left: 5,bottom: 10),
                  height: 15,
                  width: width*.6,
                  child: Text("description description description description",overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black54),),
                ),
                Container(
                  height: 15,
                  width: width*.8,
                  margin: EdgeInsets.only(top: 5,left: 5,bottom: 5),
                  child: Text.rich(TextSpan(text: "Admin-",children: [TextSpan(text: "saikumarreddy atluri",style: TextStyle(color: Colors.black87))]),overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black54))),
                Container(
                  height: 15,
                  width: width*.8,
                  margin: EdgeInsets.only(left: 5),
                  child: Text.rich(TextSpan(text: "date-",children: [TextSpan(text: "12-09-2019",style: TextStyle(color: Colors.black87))]),overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black54))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.favorite_border),
                          onPressed: (){
                            
                          },
                        ),
                    Text("2000")
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      height: height*.05,
                      width: width*.4,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: width*.20,
                            top:0,
                            child: Container(
                              height: height*.05,
                              width: height*.05,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            left: width*.20-height*.020,
                            top: 0,
                            child: Container(
                            height: height*.05,
                            width: height*.05,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              shape: BoxShape.circle,
                            ),
                          ),
                          ),
                          Positioned(
                            left: width*.20-2*height*.020,
                            top: 0,
                            child: Container(
                            height: height*.05,
                            width: height*.05,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text("12+"),)
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class AllProjects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height=MediaQuery.of(context).size.height;
    final double width=MediaQuery.of(context).size.width;

    return Container(
      
    );
  }
}