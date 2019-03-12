import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei/ui/establishment_activity.dart';
import 'package:flutter/material.dart';

class EstablishmentTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  final String documentId;

  EstablishmentTile(this.snapshot, this.documentId);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["image"]),
      ),
      title: Text(snapshot.data["title"]),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EstablishmentActivity(snapshot, documentId)));
      },
    );
  }
}
