import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Screens/pages/Posts.dart';
import 'package:troupe/Screens/profile/Settings.dart';
import 'package:troupe/Values/FadeTransition.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

// ignore: must_be_immutable
class ViewProfile extends StatefulWidget {
  String email;
  ViewProfile(this.email);

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  void initState() {
    super.initState();
    loaddata();
  }

  String username;
  loaddata() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.email)
        .get()
        .then((value) {
      var data = value.data();
      setState(() {
        username = data['username'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Collections By $username",
            style: GoogleFonts.questrial(),
          ),
          centerTitle: true,
        ),
        body: Material(
          child: Column(
            children: [
              Expanded(child: Posts(widget.email)),
            ],
          ),
        ));
  }
}
