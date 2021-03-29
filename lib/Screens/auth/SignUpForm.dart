import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Screens/WelcomeScreen.dart';
import 'package:troupe/Screens/auth/Authentication.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String name, email, pass;

  submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(name);
      print(email);
      print(pass);
      AuthenticationService auth = AuthenticationService(_auth);
      var id = await auth.signUp(email: email, password: pass);
      if (id.length != 0) {
        Alert(message: id, shortDuration: false).show();

        _emailController.text = "";
        _nameController.text = "";
        _passwordController.text = "";
        FirebaseFirestore.instance
            .collection("Users")
            .doc(_auth.currentUser.email)
            .update({"name": name}).then((value) => {});
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
          return WelcomeScreen();
        }));
      }
    }
  }

  namechangeVal(String value) {
    name = value;
    setState(() {});
  }

  emailchangeVal(String value) {
    email = value;
    setState(() {});
  }

  passchangeVal(String value) {
    pass = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: WillPopScope(
        onWillPop: () {
          return Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => WelcomeScreen()));
        },
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: orange,
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
                        "Create",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 40.0,
                          color: blueblack,
                        ),
                      ),
                      Text(
                        "Account",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 40.0,
                          color: blueblack,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: blueblack, width: 3.0))),
                          child: TextFormField(
                            controller: _nameController,
                            style: GoogleFonts.poppins(
                              color: blueblack,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                                labelStyle: GoogleFonts.poppins(color: peach),
                                labelText: "Name",
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: blueblack, width: 3.0))),
                          child: TextFormField(
                            controller: _emailController,
                            style: GoogleFonts.poppins(
                              color: blueblack,
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
                                  bottom: BorderSide(
                                      color: blueblack, width: 3.0))),
                          child: TextFormField(
                            controller: _passwordController,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: blueblack,
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
                        "Sign Up",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 30.0,
                          color: blueblack,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: blueblack,
                        radius: 30.0,
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: peach,
                            ),
                            onPressed: () {}),
                      ),
                    ],
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
