import 'dart:async';
import 'package:a20/models/otpModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:pin_view/pin_view.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

RepOtp blocOtp = RepOtp();

//type = google || normal
class OTP extends StatefulWidget {
  final String mailId, id, type;
  OTP({this.mailId, this.id, this.type});
  State<StatefulWidget> createState() {
    return OTPState();
  }
}

bool resend, otpDone;
int secs;

class OTPState extends State<OTP> {
  String otp;
  @override
  void initState() {
    resend = otpDone = false;
    secs = 30;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF7BB600),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: ListView(
        padding: EdgeInsets.all(40.0),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("OTP",
                  style: TextStyle(
                    fontFamily: 'Maison',
                    color: Color(0xFF0A98BD),
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  )),
              Padding(padding: EdgeInsets.only(top: 17.0)),
              Text("Verify your mobile number ${widget.id}",
                  style: TextStyle(
                    fontFamily: 'Maison',
                    color: Color(0xFF787993),
                    fontSize: 16.0,
                  )),
              Padding(padding: EdgeInsets.only(top: 127.0)),
              PinView(
                  count: 6, // count of the fields, excluding dashes
                  autoFocusFirstField: true,
                  // describes the dash positions (not indexes)
                  sms: SmsListener(
                      // this class is used to receive, format and process an sms
                      from: "BZ-SKILLL",
                      formatBody: (String body) {
                        return body.split(" ")[0];
                      }),
                  submit: (String pin) {
                    setState(() {
                      otp = pin;
                      otpDone = true;
                    });
                    //Verify your otp here
                  } // gets triggered when all the fields are filled
                  ),
              Padding(padding: EdgeInsets.only(top: 55.0)),

              //Submit button
              Container(
                width: MediaQuery.of(context).size.width - 80,
                alignment: Alignment.center,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    color: Color(0xFFC8E6C6),
                    child: Text("Submit",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Maison',
                          color: Color(0xFF7BB600),
                        )),
                    onPressed: () {
                      if (!otpDone) {
                        print("otp data is null");
                        Fluttertoast.showToast(msg: "Please fill the your otp");
                      } else {
                        print("reading otp");

                        //verify otp here -------

                      }
                    }),
              ),

              //Resend OTP
              Container(
                  width: MediaQuery.of(context).size.width - 80,
                  alignment: Alignment.center,
                  child: !resend
                      //Resend Button
                      ? Center(
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              color: Color(0xFFFFCDD2),
                              child: Text("Resend Otp",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Maison',
                                    color: Colors.redAccent,
                                  )),
                              onPressed: () async {
                                setState(() {
                                  resend = true;
                                });
                                Timer.periodic(Duration(seconds: 1),
                                    (callback) {
                                  blocOtp.rebuildStates();
                                  secs--;
                                  if (secs == 0) {
                                    callback.cancel();
                                    setState(() {
                                      resend = false;
                                      secs = 30;
                                    });
                                  }
                                });
                              }),
                        )
                      :

                      //Resend Waiting Widget
                      Container(
                          padding: EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Resend Otp  ",
                                style: TextStyle(color: Colors.red),
                              ),
                              CupertinoActivityIndicator(),
                              StateBuilder(
                                  blocs: [blocOtp],
                                  tag: "otp",
                                  builder: (context, otp) {
                                    return Container(
                                      child: Text("  $secs"),
                                    );
                                  }),
                            ],
                          ))),
            ],
          )
        ],
      ),
    );
  }
}
