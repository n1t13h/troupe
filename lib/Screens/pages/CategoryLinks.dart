import 'package:any_link_preview/any_link_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:url_launcher/url_launcher.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class CategoryLink extends StatefulWidget {
  String cateid;
  String uid;
  CategoryLink(this.cateid, this.uid);
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
          stream:
              query.where('collectionid', isEqualTo: widget.cateid).snapshots(),
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
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      color: blueblack,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(querySnapshot.docs[index]['title'],
                                style: GoogleFonts.poppins(
                                    color: orange,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnyLinkPreview(
                              titleStyle: GoogleFonts.poppins(color: orange),
                              link: querySnapshot.docs[index]['link'],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "in ${querySnapshot.docs[index]['collectionname']} @ $username",
                                style: GoogleFonts.poppins(
                                    color: orange,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
