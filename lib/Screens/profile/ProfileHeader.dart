import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Values/AppColors.dart';

// ignore: must_be_immutable
class ProfileHeader extends StatefulWidget {
  String uid;
  ProfileHeader(this.uid);
  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String username;
  String image;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loaddata();
    });
  }

  loaddata() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.uid)
        .get()
        .then((value) {
      var data = value.data();
      setState(() {
        username = data['username'];
        image = data['photo'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        username,
        style: GoogleFonts.questrial(
            fontWeight: FontWeight.bold, color: orange, fontSize: 20.0),
      ),
    );
  }
}
