import 'package:a20/auth/schoolSearch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login.dart';

final _formKey = GlobalKey<FormState>();
final _scaffoldKey = GlobalKey<ScaffoldState>();
PersistentBottomSheetController controller;
SearchMe me;
List<Widget> databaseSchool = [];
//databaseSchools = realSchool;
List databaseRealSchool = [];

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var _selectedSchool;
  changeCallMe(data) {
    _selectedSchool = data;
    print(data["name"]);
    setState(() {
      schoolStatus = false;
    });
  }

  Widget tempWidget() {
    return Container(
      child: Text("data"),
    );
  }

  var name, email, number, userSchool, schoolNum;
  bool pass, rpass, _autoValidate, btnStatus, schoolStatus;
  TextEditingController pass1, pass2;
  FirebaseUser user;
  Future getSchools() async {
    databaseRealSchool.clear();
    databaseSchool.clear();
    await Firestore.instance
        .collection("schools")
        .getDocuments()
        .then((schoolData) async {
      print("schools are generating $schoolData");
      schoolData.documents.forEach((sdocs) => {
            databaseRealSchool.add(sdocs.documentID),
            databaseSchool.add(Text("${sdocs.documentID}")),
            print(sdocs.documentID),
          });
    }).catchError((onError) {
      print("Smtng went wrong $onError");
    });
    return true;
  }

  //Opening Bottom sheet
  openPersistentBottomController(BuildContext context) {
    controller =
        _scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      return Container(
        height: 240,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(width: 0.1, color: Colors.black),
                    bottom: BorderSide(width: 0.1, color: Colors.black)),
              ),
              padding: EdgeInsets.only(left: 20, right: 20),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: CupertinoColors.destructiveRed),
                      )),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          schoolStatus = false;
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(color: CupertinoColors.activeBlue),
                      ))
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  schoolStatus = false;
                  Navigator.pop(context);
                });
              },
              child: Container(
                  height: 200,
                  color: CupertinoColors.black,
                  child: CupertinoPicker(
                      itemExtent: 40,
                      children: databaseSchool,
                      onSelectedItemChanged: (data) {
                        schoolNum = data;
                        print(databaseRealSchool[data]);
                      })),
            ),
          ],
        ),
      );
    });
  }

  //Authentication starts here
  final FirebaseAuth _auth = FirebaseAuth.instance;
  checkNumberExists(id) async {
    //Check user phone number exists or not
    var insStatus = await Firestore.instance
        .collection("biher/data/users")
        .where("mobile", isEqualTo: id)
        .getDocuments();
    if (insStatus.documents != null) {
      //phone number already exists
      setState(() {
        btnStatus = !btnStatus;
      });
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Student ID is already registered')));
    } else {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        print("We got a new user :)");
        DocumentReference reference =
            Firestore.instance.document("users/" + number);
        await reference.setData({
          "name": name,
          "email": email,
          "pic": " ",
          "school": databaseRealSchool[schoolNum]
        });
        user.user.sendEmailVerification();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('An Email is sent to you for verification'),
          duration: Duration(seconds: 4),
        ));
        await Future.delayed(Duration(seconds: 4));

        //Send user to verify phone number
        Navigator.pop(context);
      }).catchError((onError) {
        print("its error time $onError");
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Email already exists')));
        setState(() {
          btnStatus = !btnStatus;
        });
      });
    }
  }

  @override
  void initState() {
    getSchools();
    schoolStatus = true;
    schoolNum = 0;
    btnStatus = true;
    userSchool = 0;
    pass = rpass = true;
    _autoValidate = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 80),
                child: Text(
                  "Sign up",
                  style: TextStyle(
                      color: CupertinoColors.activeBlue,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 16),
                  child: Text(
                    "Create an account to \nstart reporting unwanted incidents",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  )),

              //Form data starts here
              Container(
                margin: EdgeInsets.only(top: 60),
                child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              alignLabelWithHint: true, hintText: "Full Name"),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Name can\'nt be null';
                            } else {
                              name = value;
                            }
                            return null;
                          },
                        ),
                        // GestureDetector(
                        //   onTap: () => openPersistentBottomController(context),
                        //   child: Container(
                        //     padding: EdgeInsets.only(bottom: 8),
                        //     decoration: BoxDecoration(
                        //         border: Border(
                        //       bottom:
                        //           BorderSide(color: Colors.black54, width: 0.5),
                        //     )),
                        //     margin: EdgeInsets.only(top: 25),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: <Widget>[
                        //         (schoolStatus)
                        //             ? Text(
                        //                 "Select your school",
                        //                 style: TextStyle(
                        //                     fontSize: 16,
                        //                     color: Colors.black54),
                        //               )
                        //             : Text(databaseRealSchool[schoolNum]),
                        //         Icon(Icons.arrow_drop_down_circle)
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        schoolStatus
                            ? Container(
                                height: 120,
                                child: SearchMe(
                                  callme: changeCallMe,
                                ))
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    schoolStatus = !schoolStatus;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 25),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(_selectedSchool["name"]),
                                          Hero(
                                            tag: "searchList",
                                            child: Icon(Icons.arrow_drop_down),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 0.3,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ),

                        //Student ID text field
                        Container(
                          margin: EdgeInsets.only(top: 18),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                alignLabelWithHint: true,
                                hintText: "Phone Number"),
                            validator: (value) {
                              if (value.length != 10) {
                                return 'Please enter a valid Student ID';
                              } else {
                                number = value;
                                return null;
                              }
                            },
                          ),
                        ),

                        //Email field widget
                        Container(
                          margin: EdgeInsets.only(top: 18),
                          child: TextFormField(
                            decoration: InputDecoration(
                                focusColor: Color(0xff0bc548),
                                hintText: "Email address"),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              Pattern pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = RegExp(pattern);
                              if (!regex.hasMatch(value)) {
                                return 'Enter Valid Email';
                              } else {
                                email = value;
                                return null;
                              }
                            },
                          ),
                        ),

                        //Password field
                        Container(
                          margin: EdgeInsets.only(top: 18),
                          child: TextFormField(
                            obscureText: pass,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: "Password",
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      pass = !pass;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: (pass) ? Colors.grey : Colors.black,
                                  )),
                            ),
                            validator: (value) {
                              if (value.length < 7) {
                                return 'Password should be atleast 8 characters';
                              } else {
                                password = value;
                              }
                              return null;
                            },
                          ),
                        ),

                        //Pass2 widget
                        Container(
                          margin: EdgeInsets.only(top: 18),
                          child: TextFormField(
                            obscureText: rpass,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        rpass = !rpass;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color:
                                          (rpass) ? Colors.grey : Colors.black,
                                    )),
                                alignLabelWithHint: true,
                                hintText: "Repeat Password"),
                            validator: (data) {
                              if (password != data) {
                                return 'Please check your passwords';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                            width: 200,
                            height: 50,
                            margin: EdgeInsets.only(top: 50, bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
                            child: (btnStatus)
                                ? CupertinoButton(
                                    color: CupertinoColors.activeBlue,
                                    onPressed: () async {
                                      setState(() {
                                        _autoValidate = true;
                                      });
                                      if (schoolStatus)
                                        Fluttertoast.showToast(
                                            msg: "Please select your School");
                                      if (_formKey.currentState.validate() &&
                                          !schoolStatus) {
                                        setState(() {
                                          btnStatus = !btnStatus;
                                        });
                                        await checkNumberExists(number);
                                      }
                                    },
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                          color: CupertinoColors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : CupertinoActivityIndicator()),
                        Container(
                          margin: EdgeInsets.only(top: 40, bottom: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "I already have an account. ",
                                style: TextStyle(
                                  color: CupertinoColors.activeBlue,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  child: Text(
                                    "Login",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(
                                      color: CupertinoColors.activeBlue,
                                      width: 1.0,
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
