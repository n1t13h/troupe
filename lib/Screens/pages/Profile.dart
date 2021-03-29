import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Screens/pages/Posts.dart';
import 'package:troupe/Screens/profile/Settings.dart';
import 'package:troupe/Values/FadeTransition.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    loaddata();
  }

  String username;
  loaddata() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(_auth.currentUser.email)
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
    return Material(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                    child: Image.network(
                  _auth.currentUser.photoURL,
                  fit: BoxFit.cover,
                  width: 90.0,
                  height: 90.0,
                )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        username == null
                            ? _auth.currentUser.displayName
                            : username,
                        style: GoogleFonts.questrial(fontSize: 35.0)),
                  ),
                ),
                IconButton(
                    icon: Icon(AntDesign.setting),
                    onPressed: () {
                      Navigator.of(context)
                          .push(FadeRoute(page: ProfileSettings()));
                    })
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              thickness: 1.0,
            ),
          ),
          Center(
            child: Text(
              "Your Collections",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(child: Posts(_auth.currentUser.uid)),
        ],
      ),
    );
  }
}
