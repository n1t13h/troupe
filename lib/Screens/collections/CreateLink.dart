import 'package:alert/alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:troupe/Values/methods.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CreateLink extends StatefulWidget {
  CreateLink({Key key}) : super(key: key);

  @override
  _CreateLinkState createState() => _CreateLinkState();
}

class _CreateLinkState extends State<CreateLink> {
  String link;
  String name;
  String username;
  String collection;
  String collectionid;
  List<DropdownMenuItem> items = [];
  @override
  void initState() {
    super.initState();
    loaddata();
  }

  loaddata() {
    FirebaseFirestore.instance
        .collection("usercollections")
        .where('uid', isEqualTo: _auth.currentUser.uid)
        .get()
        .then((value) {
      var data = value.docs.toList();
      for (var item in data) {
        setState(() {
          items.add(DropdownMenuItem(
            child: Text(item['name']),
            value: item['name'] + "." + item.id,
          ));
        });
      }
      print(data);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create A Link",
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: blueblack,
      ),
      body: SingleChildScrollView(
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
                          bottom: BorderSide(color: blueblack, width: 2.0))),
                  child: TextFormField(
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
                        labelText: "Title / Name of link",
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
                          bottom: BorderSide(color: blueblack, width: 2.0))),
                  child: TextFormField(
                    style: GoogleFonts.poppins(
                      color: blueblack,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      setState(() {
                        link = value;
                      });
                    },
                    decoration: InputDecoration(
                        labelStyle: GoogleFonts.poppins(color: blueblack),
                        labelText: "Enter Link Here",
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
                          bottom: BorderSide(color: blueblack, width: 0.0))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                    child: DropdownButton(
                      value: collectionid,
                      hint: Text("Select A Collection"),
                      items: items,
                      style: GoogleFonts.poppins(
                        color: blueblack,
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (value) {
                        setState(() {
                          collectionid = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: blueblack,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                // height: 300.0,
                width: MediaQuery.of(context).size.width * 0.9,
                child: link == null
                    ? Center(
                        child: Text(
                        "Enter a Link First",
                        style:
                            GoogleFonts.poppins(color: orange, fontSize: 30.0),
                      ))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: name == null
                                ? Text("Add A Title")
                                : Text(name,
                                    style: GoogleFonts.poppins(
                                        color: orange,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold)),
                          ),
                          AnyLinkPreview(
                              link: link,
                              displayDirection: UIDirection.UIDirectionVertical,
                              showMultimedia: true,
                              bodyMaxLines: 5,
                              bodyTextOverflow: TextOverflow.fade,
                              titleStyle: GoogleFonts.poppins(
                                color: orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              placeholderWidget: Text("Something"),
                              bodyStyle: GoogleFonts.questrial(
                                  color: peach, fontSize: 12),
                              cache: Duration(days: 7),
                              backgroundColor: blueblack,
                              boxShadow: [
                                BoxShadow(blurRadius: 0, color: Colors.grey)
                              ]),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: collectionid == null
                                ? Text("Select a Collection")
                                : Text(
                                    "in ${collectionid.replaceFirst(RegExp(r"\.[^]*"), "")} @ $username",
                                    style: GoogleFonts.poppins(
                                        color: orange,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection("links").add({
                  "link": link,
                  "title": name,
                  "uid": _auth.currentUser.uid,
                  "collectionname":
                      collectionid.replaceFirst(RegExp(r"\.[^]*"), ""),
                  "collectionid": collectionid.split('.').last,
                  "searchList": setSearchParam(name),
                });
                Alert(message: "${name} created successfully!").show();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(primary: blueblack),
              child: Text(
                "Add Link to Collection",
                style: GoogleFonts.poppins(
                    fontSize: 20.0, fontWeight: FontWeight.bold, color: orange),
              ))
        ],
      )),
    );
  }
}
