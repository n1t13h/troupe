import 'package:any_link_preview/any_link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Screens/pages/CategoryLinks.dart';
import 'package:troupe/Screens/profile/ViewProfile.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:troupe/Values/FadeTransition.dart';
import 'package:troupe/Values/methods.dart';
import 'package:url_launcher/url_launcher.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LinkFeed extends StatefulWidget {
  @override
  _LinkFeedState createState() => _LinkFeedState();
}

class _LinkFeedState extends State<LinkFeed> {
  Query query = FirebaseFirestore.instance.collection('links');

  Future<void> _launchInWebViewOrVC(String url) async {
    print("In the function");
    await launch(url.toString());
  }

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
                        .where('searchList', arrayContains: searchterm)
                        .snapshots(),
                builder: (context, stream) {
                  if (stream.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (stream.hasError) {
                    return Center(child: Text(stream.error.toString()));
                  }

                  QuerySnapshot querySnapshot = stream.data;
                  print(querySnapshot.docs);
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: querySnapshot.docs.length,
                      itemBuilder: (context, index) {
                        String username =
                            getUserName(querySnapshot.docs[index]['uid']);
                        print(username);

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _launchInWebViewOrVC(querySnapshot
                                        .docs[index]['link']
                                        .toString());
                                  },
                                  child: AnyLinkPreview(
                                      showMultimedia: true,
                                      displayDirection:
                                          UIDirection.UIDirectionHorizontal,
                                      link: querySnapshot.docs[index]['link']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Text(
                                            "${querySnapshot.docs[index]['title']} ",
                                            style: GoogleFonts.poppins(
                                                color: orange,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(FadeRoute(
                                              page: CategoryLink(
                                                  querySnapshot.docs[index]
                                                      ['collectionid'],
                                                  querySnapshot.docs[index]
                                                      ['uid'])));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Text(
                                              "in ${querySnapshot.docs[index]['collectionname']}",
                                              style: GoogleFonts.poppins(
                                                  color: orange,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(FadeRoute(
                                              page: ViewProfile(querySnapshot
                                                  .docs[index]['uid'])));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Text(" @ $username",
                                              style: GoogleFonts.poppins(
                                                  color: blueblack,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
