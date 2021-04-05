import 'package:alert/alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Screens/HomePage.dart';
import 'package:troupe/Screens/auth/Authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:troupe/Values/Routes.dart';
import 'package:velocity_x/velocity_x.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image(
                  image: AssetImage("assets/logo.png"),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Share Your Collection",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 25.0)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Create and share your collection with others",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400, fontSize: 20.0)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        AntDesign.google,
                        color: orange,
                      ),
                    ),
                    Expanded(
                      child: Text("Continue With Google",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: orange)),
                    ),
                  ],
                ),
                onPressed: () async {
                  AuthenticationService authenticationService =
                      AuthenticationService(_auth);
                  await authenticationService.gsignIn();
                  if (_auth.currentUser != null) {
                    Alert(message: "Signed In as ${_auth.currentUser.email}")
                        .show();

                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(_auth.currentUser.uid)
                        .get()
                        .then((value) {
                      var data = value.data();
                      try {
                        if (data == null) {
                          print("Username DOES NOT Exists");
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(_auth.currentUser.uid)
                              .set({
                            "username": _auth.currentUser.email
                                .replaceFirst(RegExp(r"\@[^]*"), ""),
                            "photo": _auth.currentUser.photoURL,
                            "name": _auth.currentUser.displayName,
                            "searchList": setSearchParam(_auth.currentUser.email
                                .replaceFirst(RegExp(r"\@[^]*"), "")),
                          });
                        } else {
                          print(_auth.currentUser.email);
                          // FirebaseFirestore.instance
                          //     .collection("Users")
                          //     .doc(_auth.currentUser.email)
                          //     .set({
                          //   "username": _auth.currentUser.email
                          //       .replaceFirst(RegExp(r"\@[^]*"), "")
                          // });
                        }
                      } catch (e) {
                        Alert(message: e.toString()).show();
                      }
                    });
                    context.vxNav.clearAndPush(Uri.parse(MyRoutes.homeRoute));
                  } else {
                    Alert(
                            message: "Something Went  Wrong",
                            shortDuration: false)
                        .show();
                  }
                },
                padding: EdgeInsets.fromLTRB(50.0, 15.0, 50.0, 15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                    side: BorderSide(color: blueblack, width: 3.0)),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
