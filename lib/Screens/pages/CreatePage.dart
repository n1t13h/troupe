import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Screens/collections/CreateCollection.dart';
import 'package:troupe/Screens/collections/CreateLink.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:troupe/Values/FadeTransition.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(FadeRoute(page: CreateCollection()));
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    height: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: blueblack,
                    ),
                    child: Center(
                      child: Text(
                        "Create a collection",
                        style: GoogleFonts.poppins(
                            color: orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(FadeRoute(page: CreateLink()));
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    height: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: orange,
                      // image: DecorationImage(
                      //     fit: BoxFit.cover,
                      //     colorFilter: new ColorFilter.mode(
                      //         Colors.yellow.withOpacity(0.8), BlendMode.dstATop),
                      //     image: NetworkImage(
                      //         "https://images.unsplash.com/photo-1458682625221-3a45f8a844c7?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=967&q=80")),
                    ),
                    child: Center(
                      child: Text(
                        "Add Link To Collection",
                        style: GoogleFonts.questrial(
                            color: blueblack,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
