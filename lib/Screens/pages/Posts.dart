import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Screens/pages/CategoryLinks.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:troupe/Values/FadeTransition.dart';
import 'package:troupe/Values/Routes.dart';
import 'package:troupe/Values/methods.dart';
import 'package:velocity_x/velocity_x.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Posts extends StatefulWidget {
  String email;
  Posts(this.email);
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  Query query = FirebaseFirestore.instance.collection('usercollections');

  String username;
  loaddata() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.email)
        .get()
        .then((value) {
      var data = value.data();
      print(data);
      setState(() {
        username = data['username'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loaddata();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: query.where('uid', isEqualTo: widget.email).snapshots(),
      builder: (context, stream) {
        if (stream.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (stream.hasError) {
          return Center(child: Text(stream.error.toString()));
        }

        QuerySnapshot querySnapshot = stream.data;
        print(querySnapshot.docs);

        return GridView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: querySnapshot.docs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    context.vxNav.push(Uri(
                        path: MyRoutes.collectionRoute,
                        queryParameters: {
                          'id': querySnapshot.docs[index].id,
                          'uid': widget.email
                        }));
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
                                blueblack.withOpacity(0.6), BlendMode.dstATop)),
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
                              "$username",
                              style: GoogleFonts.homemadeApple(
                                  fontSize: 25.0,
                                  color: orange.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w900),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
