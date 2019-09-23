import 'dart:io';
import 'package:a20/views/homescreen.dart';
import 'package:a20/views/notifications/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

var email, password, forgotEmail;
bool pass, _autoValidate, chinnaValidate, btnStatus;
TextEditingController pass1, pass2;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthResult authData;
  bool status;

  //Handling google signin
  Future _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    authData = await _firebaseAuth.signInWithCredential(credential);
    assert(authData.user.email != null);
    assert(authData.user.displayName != null);
    assert(!authData.user.isAnonymous);
    assert(await authData.user.getIdToken() != null);
    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(authData.user.uid == currentUser.uid);
    if (authData.user.email != null) {
      SharedPreferences data = await SharedPreferences.getInstance();
      data.setInt("login", 1);
      status = true;
      print(authData.user);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StartingScreen()));
    } else {
      print("smtng went wrong");
      status = false;
    }
  }

  getEmail(email, password) async {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email)) {
      await Firestore.instance.document("users/$email").get().then((mydata) {
        var userEmail = mydata["email"];
        print(userEmail);
        check(userEmail, password);
      }).catchError((onError) {
        setState(() {
          btnStatus = !btnStatus;
        });
        Fluttertoast.showToast(msg: "Please check your credentials");
        print(onError);
      });
    } else {
      check(email, password);
    }
  }

  check(String email, String password) async {
    _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {
      if (user.user.isEmailVerified) {
        print("User all set to rock");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await Firestore.instance
            .collection("users")
            .getDocuments()
            .then((docs) {
          docs.documents.forEach((dr) => {
                if (dr["email"] == email)
                  {
                    prefs.setBool("statusStudent", true),
                    prefs.setString("id", dr.data["id"]),
                    prefs.setString("name", dr.data["name"]),
                    prefs.setString("email", user.user.email),
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (Route<dynamic> route) => false),
                  }
              });
        });
        // DocumentSnapshot dr =
        //     await Firestore.instance.document("users/${user.user.email}").get();
      } else {
        setState(() {
          btnStatus = !btnStatus;
        });
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Your email is not verified'),
          action: SnackBarAction(
            label: "Send Email",
            onPressed: () {
              user.user.sendEmailVerification().then((onValue) {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Email sent to $email"),
                ));
              });
            },
          ),
          duration: Duration(seconds: 8),
        ));
      }
    }).catchError((onError) {
      setState(() {
        btnStatus = !btnStatus;
      });
      print(onError);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Invalid Credentials"),
      ));
    });
  }

  forgotEmailCheck() async {
    _firebaseAuth.sendPasswordResetEmail(email: forgotEmail).then((onValue) {
      print("Forgot mail sent to $forgotEmail");
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Email sent successfully"),
      ));
      // Fluttertoast.showToast(msg: "Email sent successfully");
    }).catchError((onError) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Email is not Registered"),
        action: SnackBarAction(
          label: "Register",
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Signup())),
        ),
      ));
      // Fluttertoast.showToast(msg: "Email is not Registered");
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    btnStatus = true;
    pass = true;
    _autoValidate = chinnaValidate = false;
    forgotEmail = "";
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _forgotFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var _heigth = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 80),
                  child: Image.asset(
                    "assets/logo.png",
                    height: 100,
                    width: 100,
                  )),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Welcome!",
                  style: TextStyle(
                      color: CupertinoColors.activeBlue,
                      fontSize: 28,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Enter your credentials to continue",
                  style: TextStyle(
                      color: CupertinoColors.activeBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),

              //Form data starts here
              Container(
                margin: EdgeInsets.only(top: 60),
                child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(bottom: 8),
                            width: _width,
                            child: Text("Email or Phone number")),
                        //Email Input field
                        TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.black12,
                              hintText: "Email / Phone Number"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field can\'t be empty';
                            } else {
                              email = value;
                              return null;
                            }
                          },
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 5),
                          width: _width,
                          child: Text("Password"),
                        ),
                        //Password Inputfield
                        TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.black12,
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
                          obscureText: pass,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'This field can\'t be null';
                            } else {
                              password = value;
                              return null;
                            }
                          },
                        ),
                        Container(
                            width: 180,
                            height: 50,
                            margin: EdgeInsets.only(top: 50, bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100)),
                            child: (btnStatus)
                                ? CupertinoButton(
                                    color: CupertinoColors.activeBlue,
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        color: CupertinoColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      _firebaseAuth.verifyPhoneNumber(
                                          // phoneNumber: "+919989139063",
                                          phoneNumber: "+919515792944",
                                          codeAutoRetrievalTimeout: (s) {},
                                          verificationCompleted: (s) {
                                            print(
                                                "Verification success with $s");
                                          },
                                          verificationFailed: (s) {
                                            print(
                                                "Verification failed coz ${s.message}");
                                          },
                                          codeSent: (data, [datas]) {
                                            print("sent data $data, $datas");
                                          },
                                          timeout: Duration(seconds: 5));
                                      // setState(() {
                                      //   _autoValidate = true;
                                      // });
                                      // if (_formKey.currentState.validate()) {
                                      //   setState(() {
                                      //     btnStatus = !btnStatus;
                                      //   });
                                      //   getEmail(email, password);
                                      // }
                                    })
                                : CupertinoActivityIndicator(
                                    radius: 10,
                                  )),

                        //Forgot password
                        Container(
                            margin: EdgeInsets.only(top: 15),
                            child: GestureDetector(
                              onTap: () => (Platform.isAndroid)
                                  ? showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Forgot Password ?",
                                              style: TextStyle(
                                                  color: CupertinoColors
                                                      .activeBlue)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          content: Form(
                                            key: _forgotFormKey,
                                            autovalidate: chinnaValidate,
                                            child: Container(
                                              height: 80,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    // margin:
                                                    //     EdgeInsets.only(top: 18),
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              "Enter your Email"),
                                                      onChanged: (data) {
                                                        forgotEmail = data;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            GestureDetector(
                                                child: Text("Cancel"),
                                                onTap: () =>
                                                    Navigator.pop(context)),
                                            GestureDetector(
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: CupertinoColors
                                                            .activeBlue,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    padding: EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                        top: 12,
                                                        bottom: 12),
                                                    child: Text(
                                                      "Send Email",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                onTap: () {
                                                  Pattern pattern =
                                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                  RegExp regex =
                                                      RegExp(pattern);
                                                  if (!regex
                                                      .hasMatch(forgotEmail)) {
                                                    _scaffoldKey.currentState
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            "Email is not valid"),
                                                        duration: Duration(
                                                            seconds: 3),
                                                      ),
                                                    );
                                                  } else {
                                                    forgotEmailCheck();
                                                  }
                                                }),
                                          ],
                                        );
                                      })
                                  : showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text("Forgot Password"),
                                          content: Form(
                                            key: _forgotFormKey,
                                            autovalidate: chinnaValidate,
                                            child: Container(
                                              height: 50,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 18),
                                                    child: CupertinoTextField(
                                                      placeholder:
                                                          "Enter your Email ID",
                                                      onChanged: (data) {
                                                        forgotEmail = data;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            CupertinoButton(
                                                child: Text("Cancel"),
                                                onPressed: () =>
                                                    Navigator.pop(context)),
                                            CupertinoButton(
                                                child: Text("Send Email"),
                                                onPressed: () {
                                                  Pattern pattern =
                                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                  RegExp regex =
                                                      RegExp(pattern);
                                                  if (!regex
                                                      .hasMatch(forgotEmail)) {
                                                    _scaffoldKey.currentState
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            "Email is not valid"),
                                                        duration: Duration(
                                                            seconds: 3),
                                                      ),
                                                    );
                                                  } else {
                                                    forgotEmailCheck();
                                                  }
                                                }),
                                          ],
                                          // actions: <Widget>[
                                          //   CupertinoDialogAction(
                                          //     isDefaultAction: true,
                                          //     child: Text("Yes"),
                                          //   ),
                                          //   CupertinoDialogAction(
                                          //     child: Text("No"),
                                          //   )
                                          // ],
                                        );
                                      }),
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                    color: CupertinoColors.activeBlue,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),

                        RaisedButton(
                          child: Text("Test Button"),
                          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Notifications())),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 100),
                          child: GoogleSignInButton(
                            onPressed: () => _handleSignIn(),
                            darkMode: true,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Still without account? ",
                                style: TextStyle(
                                  color: CupertinoColors.activeBlue,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Signup())),
                                child: Container(
                                  child: Text(
                                    "Sign Up",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(
                                      color: CupertinoColors.activeBlue,
                                      width: 3.0,
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
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
