import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({this.clgname});
  final String clgname;
  @override
  Widget build(BuildContext context) {
    final double _height= MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('A20~$clgname',style: TextStyle(fontWeight: FontWeight.bold,color:Colors.black.withOpacity(0.65)),),
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: _height,
        width: _width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CarouselSlider(
              autoPlay: true,
              height: _height*.35,
                items: <Widget>[
                  Container(
                    child: FlutterLogo(
                      size: 30,
                    ),
                  ),
                  Container(
                    child: FlutterLogo(
                      size: 30,
                    ),
                  ),
                  Container(
                    child: FlutterLogo(
                      size: 30,
                    ),
                  ),
                  Container(
                    child: FlutterLogo(
                      size: 30,
                    ),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}