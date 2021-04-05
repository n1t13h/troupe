import 'package:any_link_preview/any_link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

// ignore: must_be_immutable
class CategoryLink extends StatefulWidget {
  String id;
  String uid;
  CategoryLink(this.id, this.uid);
  @override
  _CategoryLinkState createState() => _CategoryLinkState();
}

class _CategoryLinkState extends State<CategoryLink> {
  @override
  void initState() {
    super.initState();
    loaddata();
  }

  String username;
  loaddata() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.uid)
        .get()
        .then((value) {
      var data = value.data();
      setState(() {
        username = data['username'];
      });
    });
  }

  Query query = FirebaseFirestore.instance.collection('links');
  Future<void> _launchInWebViewOrVC(String url) async {
    print("In the function");
    context.showToast(msg: "Launching ${url}");
    await launch(url.toString());
    // print(canLaunch(url));
    // if (await canLaunch(url)) {
    //   print("HERE");
    //   await launch(url.toString());
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All links",
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: query.where('collectionid', isEqualTo: widget.id).snapshots(),
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
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _launchInWebViewOrVC(
                            querySnapshot.docs[index]['link'].toString());
                      },
                      child: kIsWeb
                          ? Card(
                              child: Container(
                              height: 100.0,
                              color: blueblack,
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(querySnapshot.docs[index]['link'],
                                    style: GoogleFonts.poppins(
                                        color: orange,
                                        fontWeight: FontWeight.w500)),
                              )),
                            ))
                          : AnyLinkPreview(
                              placeholderWidget: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Container(
                                      color: blueblack,
                                      width: MediaQuery.of(context).size.width *
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
                              displayDirection: UIDirection.UIDirectionVertical,
                              link: querySnapshot.docs[index]['link']),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
