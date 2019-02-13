import 'package:cloud_firestore/cloud_firestore.dart';

class EstablisheData {
  String image;
  String title;
  String address;
  String zipcode;
  String uf;
  String phone;
  String email;

  EstablisheData.fromDocument(DocumentSnapshot snapshot) {
    image = snapshot.data["image"];
    title = snapshot.data["title"];
    address = snapshot.data["address"];
    zipcode = snapshot.data["zipcode"];
    uf = snapshot.data["uf"];
    phone = snapshot.data["phone"];
    email = snapshot.data["email"];
  }

}