import 'package:flutter/material.dart';
import 'package:troupe/Screens/SplashScreen.dart';
import 'package:troupe/Values/AppColors.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Trouppe",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        primaryColor: orange,
        highlightColor: peach,
      ),
    );
  }
}
