import 'package:any_link_preview/any_link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Screens/pages/CategoryLinks.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:troupe/Values/FadeTransition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ndialog/ndialog.dart';
import 'package:share/share.dart';

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
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "${querySnapshot.docs[index]['title']} ",
                                            style: GoogleFonts.poppins(
                                                color: blueblack,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.more_vert_sharp),
                                        onPressed: () async {
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
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).push(FadeRoute(
                                                            page: CategoryLink(
                                                                querySnapshot
                                                                            .docs[
                                                                        index][
                                                                    'collectionid'],
                                                                querySnapshot
                                                                            .docs[
                                                                        index]
                                                                    ['uid'])));
                                                      },
                                                      child: Text(
                                                        "View Collection",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color:
                                                                    blueblack,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                    Divider(),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).push(FadeRoute(
                                                            page: CategoryLink(
                                                                querySnapshot
                                                                            .docs[
                                                                        index][
                                                                    'collectionid'],
                                                                querySnapshot
                                                                            .docs[
                                                                        index]
                                                                    ['uid'])));
                                                      },
                                                      child: Text(
                                                        "View Profile",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color:
                                                                    blueblack,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                    Divider(),
                                                    TextButton(
                                                      onPressed: () {
                                                        Share.share(
                                                            'Check Out This Link!\n${querySnapshot.docs[index]["link"]}\nShared Via *@Troupee*',
                                                            subject:
                                                                'Check This Out!');
                                                      },
                                                      child: Text(
                                                        "Share",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color:
                                                                    blueblack,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ).show(context);
                                        }),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _launchInWebViewOrVC(querySnapshot
                                        .docs[index]['link']
                                        .toString());
                                  },
                                  child: AnyLinkPreview(
                                      placeholderWidget: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          child: Container(
                                              color: blueblack,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              height: 90.0,
                                              child: Center(
                                                  child: Text(
                                                "Unable to Load Preview!Click To Open Link",
                                                style: GoogleFonts.poppins(
                                                  color: orange,
                                                ),
                                              ))),
                                        ),
                                      ),
                                      showMultimedia: true,
                                      displayDirection:
                                          UIDirection.UIDirectionVertical,
                                      link: querySnapshot.docs[index]['link']),
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
