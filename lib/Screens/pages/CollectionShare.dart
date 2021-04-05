import 'package:alert/alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'package:troupe/Screens/profile/ProfileHeader.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:share_plus/share_plus.dart';

class CollectionShare extends StatefulWidget {
  String name;
  String uid;
  String image;
  CollectionShare(this.name, this.image, this.uid);
  @override
  _CollectionShareState createState() => _CollectionShareState();
}

class _CollectionShareState extends State<CollectionShare> {
  ScreenshotController screenshotController = ScreenshotController();
  bool isReady = false;
  String username;
  @override
  void initState() {
    super.initState();
    loaddata();
  }

  loaddata() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.uid)
        .get()
        .then((value) {
      var data = value.data();
      setState(() {
        username = data['username'];
        isReady = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: !isReady
          ? CircularProgressIndicator()
          : Column(
              children: [
                Screenshot(
                  controller: screenshotController,
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
                            image: NetworkImage(widget.image),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                blueblack.withOpacity(0.6), BlendMode.dstATop)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Center(
                              child: Text(
                            widget.name,
                            style: GoogleFonts.questrial(
                                fontSize: 40.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          )),
                          Center(
                              child: Text(
                            "by",
                            style: GoogleFonts.questrial(
                                fontSize: 30.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          )),
                          Center(
                              child: Text(
                            username,
                            style: GoogleFonts.kalam(
                                fontSize: 40.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          )),
                          Spacer(),
                          Center(
                              child: Text(
                            "Troupee🔥",
                            style: GoogleFonts.poppins(
                                fontSize: 20.0,
                                color: orange,
                                fontWeight: FontWeight.w400),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final directory = (await getExternalStorageDirectory())
                        .path; //from path_provide package
                    String fileName = "troupee.jpg";

                    String path = '$directory';
                    print(path);

                    screenshotController.captureAndSave(
                      path,
                      pixelRatio: 1.5,
                      fileName:
                          fileName, //set path where screenshot will be saved
                    );
                    Alert(message: "Screenshot saved").show();
                    print(path + "/" + fileName);
                    Share.shareFiles([path + "/" + fileName],
                        text: 'CheckOut This Collection on *Troupee*');
                  },
                  child: Text("Share Collection",
                      style: GoogleFonts.poppins(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
    );
  }
}
