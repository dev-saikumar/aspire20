import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UserDetails extends ChangeNotifier{
  DocumentSnapshot ds;
  String email="siak";
  String name;
  void getdetails(String mail,String nam) async{
   if(ds==null||email!=mail){
    QuerySnapshot qs= await Firestore.instance.collection("biher").where("email",isEqualTo:mail).getDocuments();
    ds=qs.documents[0];
   }
    name=nam;
    email=mail;
  }
  void reload() async{
    ds= await Firestore.instance.collection("biher").document(email).get();
  }
}