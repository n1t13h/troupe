import 'package:flutter/material.dart';
import 'package:troupe/Screens/HomePage.dart';
import 'dart:async';

import 'package:troupe/Screens/WelcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutterfitness/screens/admin/Dashboard.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    print(_auth.currentUser);
    if (_auth.currentUser != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WelcomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
          child: Container(
        child: Image.asset(
          "assets/logo.png",
          width: 300.0,
          height: 300.0,
          filterQuality: FilterQuality.high,
        ),
      )),
    );
  }
}
