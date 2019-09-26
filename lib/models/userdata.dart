import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';



class UserDetails extends ChangeNotifier{
  DocumentSnapshot ds;
  String email="siak";

  getds()=>ds;
  String get mail =>email;

  void getdetails(String mail) async{
   if(ds==null||email!=mail){
    QuerySnapshot qs= await Firestore.instance.collection("biher").where("email",isEqualTo:mail).getDocuments();
    ds=qs.documents[0];
   }
   debugPrint("lsssssssssssssssssssssssssssssssssssssssssssssssddslllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");
    email=mail;
    notifyListeners();
  }
  void reload() async{
    ds= await Firestore.instance.collection("biher").document(email).get();
  }
}