import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryData {
  String image;
  String title;

  CategoryData.fromDocument(DocumentSnapshot snapshot) {
    image = snapshot.data["image"];
    title = snapshot.data["title"];
  }

}