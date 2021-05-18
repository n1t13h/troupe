import 'package:cloud_firestore/cloud_firestore.dart';

String getUserName(String uid) {
  String username;

  FirebaseFirestore.instance.collection("Users").doc(uid).get().then((value) {
    var data = value.data();
    print(uid);
    print(data);

    username = data['username'];
  });
  print("IAMINMETHOD");
  print(username);
  return username;
}

setSearchParam(String caseNumber) {
  List<String> caseSearchList = [];
  String temp = "";
  for (int i = 0; i < caseNumber.length; i++) {
    temp = temp + caseNumber[i].toLowerCase();
    caseSearchList.add(temp);
  }
  return caseSearchList;
}
