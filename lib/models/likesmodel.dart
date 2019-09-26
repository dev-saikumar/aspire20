import 'package:flutter/widgets.dart';


class Liker extends ChangeNotifier{
  Liker({this.li,this.count,this.bk});
  bool li;
  int count;
  bool bk;
 void toogle(){
    debugPrint("toogled");
    count=li?count-1:count+1;
    li=!li;
    notifyListeners();
  }
  void marktoogle(){
    bk=!bk;
    notifyListeners();
  }
}