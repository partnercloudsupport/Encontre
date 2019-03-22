import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RatingTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  RatingTile(this.snapshot);

Future<String> _displayName() async{
  //FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //return user.displayName;
}

Future<String> _image() async{
  //FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //return user.photoUrl;
}

  @override
  Widget build(BuildContext context) {
    print("Name: ${_displayName()}");
    print("Image: ${_image()}");
    return ListTile(
      title: Text("Rodrigo"),
      subtitle: Text(snapshot.data["text"]),
      trailing: Text(snapshot.data["rate"].toString()),
    );
  }
}
