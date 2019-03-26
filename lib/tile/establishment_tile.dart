import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei/ui/establishment_activity.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';

class EstablishmentTile extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final String documentId;
  EstablishmentTile(this.snapshot, this.documentId);

  @override
  _EstablishmentTileState createState() =>
      _EstablishmentTileState(snapshot, documentId);
}

class _EstablishmentTileState extends State<EstablishmentTile> {
  final DocumentSnapshot snapshot;
  final String documentId;
  String dist;

  _EstablishmentTileState(this.snapshot, this.documentId);

  void _calculateDistance(double lon, double lat) async {
    final Distance distance = new Distance();

    final double km = await distance.as(
        LengthUnit.Kilometer,
        new LatLng(double.parse(snapshot.data["lat"]),
            double.parse(snapshot.data["lon"])),
        new LatLng(lon, lat));

    final double meter = await distance(
        new LatLng(double.parse(snapshot.data["lat"]),
            double.parse(snapshot.data["lon"])),
        new LatLng(lon, lat));

    setState(() {
      if (km < 1) {
        dist = "Distância: ${meter.toInt()} metros";
      } else {
        dist = "Distância: ${km.toInt()} km";
      }
    });
  }

  void getCoordinate() {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    StreamSubscription<Position> positionStream = geolocator
        .getPositionStream(locationOptions)
        .listen((Position _position) {
      _position == null
          ? 0.0
          : _calculateDistance(_position.latitude, _position.longitude);
          print("Latitude: ${_position.latitude.toString()}");
          print("Longitude: ${_position.longitude.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    getCoordinate();
    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["image"]),
      ),
      title: Text(snapshot.data["title"]),
      trailing: Icon(Icons.keyboard_arrow_right),
      subtitle: dist != null ? Text("${dist}") : Text("Calculando Distância ..."),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EstablishmentActivity(snapshot, documentId)));
      },
    );
  }
}
