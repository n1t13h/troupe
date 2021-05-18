import 'package:any_link_preview/any_link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:troupe/Values/Routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ndialog/ndialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:velocity_x/velocity_x.dart';

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
                            decoration: InputDecoration(
                              labelText: "Search",
                              labelStyle: GoogleFonts.poppins(),
                            ),
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
                    ? query.orderBy("created_at", descending: true).snapshots()
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
                  return Scrollbar(
                    child: ListView.builder(
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
                                                          context.vxNav.push(Uri(
                                                              path: MyRoutes
                                                                  .collectionRoute,
                                                              queryParameters: {
                                                                'id': querySnapshot
                                                                            .docs[
                                                                        index][
                                                                    'collectionid'],
                                                              }));
                                                        },
                                                        child: Text(
                                                          "View Collection",
                                                          style: GoogleFonts
                                                              .poppins(
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
                                                          style: GoogleFonts
                                                              .poppins(
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
                                    child: kIsWeb
                                        ? Card(
                                            child: Container(
                                            height: 100.0,
                                            color: blueblack,
                                            child: Center(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  querySnapshot.docs[index]
                                                      ['link'],
                                                  style: GoogleFonts.poppins(
                                                      color: orange,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            )),
                                          ))
                                        : AnyLinkPreview(
                                            placeholderWidget: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Card(
                                                child: Container(
                                                    color: blueblack,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    height: 90.0,
                                                    child: Center(
                                                        child: Text(
                                                      "Unable to Load Preview!Click To Open \n${querySnapshot.docs[index]['link']}",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: orange,
                                                      ),
                                                    ))),
                                              ),
                                            ),
                                            showMultimedia: true,
                                            displayDirection:
                                                UIDirection.UIDirectionVertical,
                                            link: querySnapshot.docs[index]
                                                ['link']),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            querySnapshot.docs[index]['likedby']
                                                    .contains(
                                                        _auth.currentUser.uid)
                                                ? AntDesign.heart
                                                : AntDesign.hearto,
                                            color: querySnapshot.docs[index]
                                                        ['likedby']
                                                    .contains(
                                                        _auth.currentUser.uid)
                                                ? Colors.red
                                                : Colors.black,
                                          ),
                                          onPressed: () {
                                            List list = querySnapshot
                                                .docs[index]['likedby'];
                                            if (list.contains(
                                                _auth.currentUser.uid)) {
                                              list.remove(
                                                  _auth.currentUser.uid);
                                            } else {
                                              list.add(_auth.currentUser.uid);
                                            }
                                            FirebaseFirestore.instance
                                                .collection("links")
                                                .doc(querySnapshot
                                                    .docs[index].id)
                                                .update({"likedby": list});
                                          }),
                                      Text(
                                        querySnapshot.docs[index]['likedby']
                                                    .length ==
                                                0
                                            ? ""
                                            : "${querySnapshot.docs[index]['likedby'].length}",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
