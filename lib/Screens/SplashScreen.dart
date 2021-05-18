import 'package:flutter/material.dart';
import 'dart:async';
import 'package:velocity_x/velocity_x.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:troupe/Values/Routes.dart';

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
    return new Timer(Duration(seconds: 1), onDoneLoading);
  }

  onDoneLoading() async {
    print(_auth.currentUser);
    if (_auth.currentUser != null) {
      context.vxNav.clearAndPush(Uri.parse(MyRoutes.homeRoute));
    } else {
      context.vxNav.clearAndPush(Uri.parse(MyRoutes.welcomRoute));
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
