import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:troupe/Screens/pages/CreatePage.dart';
import 'package:troupe/Screens/pages/LinkFeed.dart';
import 'package:troupe/Screens/pages/Profile.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  List<Widget> _widgetOptions = <Widget>[
    LinkFeed(),
    Text(
      'Create',
      style: optionStyle,
    ),
    CreatePage(),
    Text(
      'Likes',
      style: optionStyle,
    ),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Troupe",
          style: GoogleFonts.montserrat(
              color: blueblack, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                rippleColor: peach,
                hoverColor: orange,
                gap: 8,
                activeColor: orange,
                iconSize: 20,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: blueblack,
                tabs: [
                  GButton(
                    icon: SimpleLineIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: Icons.add,
                    text: 'Create',
                  ),
                  GButton(
                    icon: SimpleLineIcons.fire,
                    text: 'Likes',
                  ),
                  GButton(
                    icon: SimpleLineIcons.user,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}
