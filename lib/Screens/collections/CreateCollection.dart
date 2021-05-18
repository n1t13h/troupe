import 'package:alert/alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:troupe/Values/methods.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CreateCollection extends StatefulWidget {
  @override
  _CreateCollectionState createState() => _CreateCollectionState();
}

class _CreateCollectionState extends State<CreateCollection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loaddata();
  }

  String username;
  loaddata() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(_auth.currentUser.uid)
        .get()
        .then((value) {
      var data = value.data();
      setState(() {
        username = data['username'];
      });
    });
  }

  String name = "",
      image =
          "https://images.unsplash.com/photo-1616929283261-30f973e00bd3?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueblack,
        title: Text(
          "Create Collection",
          style: GoogleFonts.questrial(fontSize: 20.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: blueblack, width: 1.0))),
                        child: TextFormField(
                          controller: _nameController,
                          style: GoogleFonts.poppins(
                            color: blueblack,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                          decoration: InputDecoration(
                              labelStyle: GoogleFonts.poppins(color: blueblack),
                              labelText: "Collection Name",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: blueblack, width: 1.0))),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              image = value;
                            });
                          },
                          controller: _imageController,
                          style: GoogleFonts.poppins(
                            color: blueblack,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                              labelStyle: GoogleFonts.poppins(color: blueblack),
                              labelText: "Collection Background Image",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Your Collection Will Look Like This",
                  style: GoogleFonts.poppins(fontSize: 20.0),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Container(
                    height: 300.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: blueblack,
                      image: DecorationImage(
                          image: NetworkImage(image),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              blueblack.withOpacity(0.6), BlendMode.dstATop)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          name == null ? "Enter a name" : name,
                          style: GoogleFonts.questrial(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w900),
                        )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            "by",
                            style: GoogleFonts.questrial(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            username == null
                                ? _auth.currentUser.displayName
                                : username,
                            style: GoogleFonts.questrial(
                                fontSize: 30.0,
                                color: orange,
                                fontWeight: FontWeight.w900),
                          )),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("usercollections")
                          .add({
                        "name": name,
                        "image": image,
                        "uid": _auth.currentUser.uid,
                        "isfeatured": false,
                        "searchList": setSearchParam(name),
                      });
                      Alert(message: "$name created successfully!").show();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(primary: blueblack),
                    child: Text(
                      "Create My Collection",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, color: orange),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
