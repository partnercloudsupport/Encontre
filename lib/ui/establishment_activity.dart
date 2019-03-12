import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei/tile/rating_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class EstablishmentActivity extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final String documentId;

  EstablishmentActivity(this.snapshot, this.documentId);

  @override
  _EstablishmentActivityState createState() =>
      _EstablishmentActivityState(snapshot, documentId);
}

class _EstablishmentActivityState extends State<EstablishmentActivity> {
  final DocumentSnapshot snapshot;
  final String documentId;
  _EstablishmentActivityState(this.snapshot, this.documentId);

  GoogleMapController mapController;
  GoogleSignIn googleAuth = new GoogleSignIn();

  double rate = 0;
  int med = 0;

  Widget _appBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          snapshot.data["title"],
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: Image.network(
          snapshot.data["image"],
          fit: BoxFit.cover,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.confirmation_number,
            color: Colors.white,
          ),
          onPressed: () {},
        )
      ],
    );
  }

  Widget _listTileWidget(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.blue,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _establishmentData() {
    return Card(
        elevation: 2.0,
        child: Column(
          children: <Widget>[
            _listTileWidget(
                "Endereço",
                "${snapshot.data["address"]}, Nº${snapshot.data["number"]} - ${snapshot.data["neighborhood"]}",
                Icons.location_on),
            _listTileWidget(
                "CEP",
                "${snapshot.data["zipcode"]} / ${snapshot.data["uf"]}",
                Icons.map),
            _listTileWidget("Telefone", snapshot.data["phone"], Icons.phone),
            _listTileWidget(
                "E-mail", snapshot.data["email"], Icons.alternate_email),
            _listTileWidget("Avaliações", "${rate} / 5.0", Icons.rate_review)
          ],
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      controller.addMarker(MarkerOptions(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: LatLng(double.parse(snapshot.data["lat"]),
              double.parse(snapshot.data["lon"])),
          infoWindowText: InfoWindowText(
              snapshot.data["title"], snapshot.data["address"])));
    });
  }

  Widget _mapEstablishment() {
    return Card(
      elevation: 2.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.3,
          height: MediaQuery.of(context).size.height / 3,
          child: GoogleMap(
            rotateGesturesEnabled: false,
            scrollGesturesEnabled: false,
            tiltGesturesEnabled: false,
            initialCameraPosition: CameraPosition(
                bearing: 270.0,
                tilt: 30.0,
                zoom: 17.0,
                target: LatLng(double.parse(snapshot.data["lat"]),
                    double.parse(snapshot.data["lon"]))),
            onMapCreated: _onMapCreated,
          ),
        ),
      ),
    );
  }

  Widget _rateButton() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: () async {
        if (await FirebaseAuth.instance.currentUser() != null) {
          // ? COMENTAR
        } else {
          googleAuth.signIn().then((result) {
            result.authentication.then((googleKey) {
              FirebaseAuth.instance
                  .signInWithGoogle(
                      idToken: googleKey.idToken,
                      accessToken: googleKey.accessToken)
                  .then((signInUser) {
                // ? COMENTAR
              }).catchError((e) {
                print("Google Sign Error: ${e}");
              });
            }).catchError((e) {
              print("Google Sign Error: ${e}");
            });
          }).catchError((e) {
            print("Google Sign Error: ${e}");
          });
        }
        ;
      },
      padding: EdgeInsets.all(16),
      color: Colors.blue,
      child: Text('Avaliar Estabelecimento',
          style: TextStyle(color: Colors.white)),
    );
  }

  Widget _showComments() {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance
          .collection("categories")
          .document(documentId)
          .collection("establishment")
          .document(snapshot.documentID)
          .collection("rating")
          .getDocuments(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text(
                  "Ocorreu um erro ao listar as avaliações deste estabelecimento!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700));
            } else {
              if (snapshot.data.documents.length == null ||
                  snapshot.data.documents.length == 0) {
                return Text(
                  "Este estabelecimento não tem nenhuma avaliação no momento!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700),
                );
              } else {
                return ListView(
                    shrinkWrap: true,
                    children: ListTile.divideTiles(
                            tiles: snapshot.data.documents.map<Widget>((doc) {
                              rate += doc.data["rate"];                               
                              return RatingTile(doc);
                            }).toList(),
                            color: Colors.grey[500])
                        .toList());
              }
            }
            break;
        }
      },
    );
  }

  Widget _rating() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: <Widget>[
                    _showComments(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _rateButton()
                  ],
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.share,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrooled) {
            return <Widget>[_appBar()];
          },
          body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(12.0),
            children: <Widget>[
              _establishmentData(),
              SizedBox(height: 4.0),
              _mapEstablishment(),
              SizedBox(height: 4.0),
              _rating()
            ],
          )),
    );
  }
}
