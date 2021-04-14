import 'dart:typed_data';

import 'package:alert/alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ndialog/ndialog.dart';
import 'package:troupe/Screens/pages/CategoryLinks.dart';
import 'package:troupe/Screens/pages/CollectionShare.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:troupe/Values/FadeTransition.dart';

import 'package:share_plus/share_plus.dart';
import 'package:troupe/Values/Routes.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CollectionFeed extends StatefulWidget {
  @override
  _CollectionFeedState createState() => _CollectionFeedState();
}

class _CollectionFeedState extends State<CollectionFeed> {
  Query query = FirebaseFirestore.instance.collection('usercollections');

  String searchterm;
  bool issearch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueblack,
        child: Icon(
          AntDesign.search1,
          color: orange,
        ),
        onPressed: () {
          setState(() {
            issearch = true;
          });
        },
      ),
      body: Container(
        child: Column(
          children: [
            issearch
                ? Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(labelText: "search"),
                            onChanged: (value) {
                              setState(() {
                                if (value == "") {
                                  searchterm = null;
                                } else {
                                  searchterm = value;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(AntDesign.closecircle),
                          onPressed: () {
                            setState(() {
                              issearch = false;
                              searchterm = null;
                            });
                          })
                    ],
                  )
                : Container(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: searchterm == null
                    ? query.snapshots()
                    : query
                        .where('searchList',
                            arrayContains: searchterm.toLowerCase())
                        .snapshots(),
                builder: (context, stream) {
                  if (stream.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (stream.hasError) {
                    return Center(child: Text(stream.error.toString()));
                  }

                  QuerySnapshot querySnapshot = stream.data;
                  print(querySnapshot.docs);
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: querySnapshot.docs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              MyRoutes.collectionRoute,
                              arguments: {
                                "id": querySnapshot.docs[index].id,
                              },
                            );
                          },
                          onLongPress: () async {
                            await NDialog(
                              dialogStyle: DialogStyle(
                                titleDivider: true,
                              ),
                              title: Center(
                                child: Text(
                                  "Options",
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                              content: Container(
                                child: CollectionShare(
                                    querySnapshot.docs[index]['name'],
                                    querySnapshot.docs[index]['image'],
                                    querySnapshot.docs[index]['uid']),
                              ),
                            ).show(context);
                          },
                          child: Card(
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
                                    image: NetworkImage(
                                        querySnapshot.docs[index]['image']),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                        blueblack.withOpacity(0.6),
                                        BlendMode.dstATop)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Text(
                                    querySnapshot.docs[index]['name'],
                                    style: GoogleFonts.questrial(
                                        fontSize: 35.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900),
                                  )),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
