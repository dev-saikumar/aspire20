import 'package:a20/views/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './eventspage.dart';
import './feedspage.dart';
import './projectspage.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../models/userdata.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.clgname});
  final String clgname;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
  final _scaffoldkey=GlobalKey<ScaffoldState>();
  ScrollController _controller1;
  TabController tabController;
  @override
  void initState() {
      UserDetails().getdetails(Provider.of<FirebaseUser>(context).email,Provider.of<FirebaseUser>(context).displayName);
      tabController=TabController(initialIndex: 0,length: 3,vsync: this);
      _controller1=ScrollController();
      tabController.addListener((){
        tabController.indexIsChanging?_controller1.jumpTo(_controller1.initialScrollOffset):null;
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black,statusBarIconBrightness: Brightness.light));
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldkey,
      drawer: SideBar(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu,color: Colors.black.withOpacity(0.5),),
          onPressed: ()=>_scaffoldkey.currentState.openDrawer(),
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.6)
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_active,color: Colors.indigo.withOpacity(0.4),),
            onPressed: (){

            },
          )
        ],
        title: Text(
          'A20~${widget.clgname}',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.65)),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details){
         //svalue<=0?_controller2.animateTo(_controller2.offset+(details.globalPosition.dy-dvalue),duration: Duration(milliseconds: 10),curve: Curves.easeInOut):_controller1.animateTo(_controller2.offset+details.delta.dy,duration: Duration(milliseconds: 50),curve: Curves.easeInOut);
         //dvalue=details.globalPosition.dy;
        },
        child: Container(
          height: _height,
          width: _width,
          child: ListView(
            physics: ClampingScrollPhysics(),
            controller: _controller1,
            shrinkWrap: true,
            primary: false,
            children:<Widget>[Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CarouselSlider(
                  enlargeCenterPage: true,
                  autoPlay: true,
                  height: _height * .25,
                  items: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      width: _width * .85,
                      color: Colors.green.withOpacity(0.2),
                      child: FlutterLogo(
                        size: 30,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      width: _width * .85,
                      color: Colors.red.withOpacity(0.1),
                      child: FlutterLogo(
                        size: 30,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      width: _width * .85,
                      color: Colors.blue.withOpacity(0.2),
                      child: FlutterLogo(
                        size: 30,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      width: _width * .85,
                      color: Colors.deepPurple.withOpacity(0.2),
                      child: FlutterLogo(
                        size: 30,
                      ),
                    )
                  ],
                ),
               Divider(
                 color: Colors.black.withOpacity(0.3),
                 thickness: 0.5,
               ),
               StickyHeader(
                 callback: (dou){
                 },
                 header: Container(
                   color: Colors.white,
                   child: TabBar(
                     controller: tabController,
                     indicatorSize: TabBarIndicatorSize.tab,
                     indicatorPadding: EdgeInsets.only(left: _width*.12,right: _width*.12),
                     indicatorColor: Colors.black.withOpacity(0.4),
                     
                     tabs: <Widget>[
                       Tab(
                         child: Text("Feed",style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                       ),
                       Tab(
                         child: Text("Events",style: TextStyle(color: Colors.black.withOpacity(0.6))),
                       ),
                       Tab(child: Text("projects",style: TextStyle(color: Colors.black.withOpacity(0.6))),)
                     ],
                   ),
                 ),
               content: Container(
                 alignment: Alignment.topCenter,
                height: _height*6,
                 child: TabBarView(
                   controller: tabController,
                   children: <Widget>[
                     SingleChildScrollView(
                       primary: true,
                       child: Feeds(),
                     ),
                     SingleChildScrollView(
                       primary: true,
                       child: EventsPage(),
                     ),
                     SingleChildScrollView(
                       primary: true,
                       child: ProjectsPage(),
                     )
                     
                   ],
                 ),
               )
               
               ),
               
              ],
            ),
            ]
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
  tabController.dispose();
  _controller1.dispose();
  super.dispose();
  }
}
