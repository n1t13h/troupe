import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Screens/WelcomeScreen.dart';
import 'package:troupe/Screens/auth/Authentication.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: blueblack,
      ),
      body: WillPopScope(
        onWillPop: () {
          return Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => WelcomeScreen()));
        },
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: blueblack,
            ),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 40.0,
                          color: orange,
                        ),
                      ),
                      Text(
                        "Back",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 40.0,
                          color: orange,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: orange, width: 3.0))),
                          child: TextFormField(
                            style: GoogleFonts.poppins(
                              color: orange,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                                labelStyle: GoogleFonts.poppins(color: peach),
                                labelText: "Email",
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: orange, width: 3.0))),
                          child: TextFormField(
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: peach,
                            ),
                            obscureText: true,
                            decoration: InputDecoration(
                                labelStyle: GoogleFonts.poppins(
                                  color: peach,
                                ),
                                labelText: "Password",
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 30.0,
                          color: peach,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: peach,
                        radius: 30.0,
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: blueblack,
                            ),
                            onPressed: () {}),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AuthenticationService authenticationService =
                        AuthenticationService(_auth);
                    authenticationService.gsignIn();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Sign In With Google",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 30.0,
                          color: orange,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
