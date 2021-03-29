import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:troupe/Screens/SplashScreen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ProfileSettings extends StatefulWidget {
  ProfileSettings({Key key}) : super(key: key);

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Column(
        children: [
          // Row(
          //   children: [
          //     TextFormField(
          //       decoration: InputDecoration(
          //         labelText: "UserName",
          //         labelStyle: GoogleFonts.questrial(),
          //       ),
          //     ),
          //   ],
          // ),
          ListTile(
            onTap: () {
              _auth.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => SplashScreen()));
            },
            title: Text(
              "Signout",
              style: GoogleFonts.poppins(),
            ),
          )
        ],
      ),
    );
  }
}
