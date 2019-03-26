import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _openPhone(String phone) async {
    if (phone.isNotEmpty) {
      if (await canLaunch("tel:${phone}")) {
        await launch("tel:${phone}");
      } else {
        throw 'Could not launch';
      }
    }
  }

  void _openEmail(String email) async {
    if (email.isNotEmpty) {
      if (await canLaunch("mailto:${email}")) {
        await launch("mailto:${email}");
      } else {
        throw 'Could not launch';
      }
    }
  }

  Widget _listTileWidget(
      String title, String subtitle, IconData icon, void func) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.blue,
      ),
      onTap: () {
        func;
      },
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _establishmentData() {
    return Card(
      elevation: 2.0,
      child: ExpandablePanel(
          header: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "INFORMAÇÕES DO ESTABELECIMENTO",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          expanded: Column(
            children: <Widget>[
              _listTileWidget("Endereço",
                  "${snapshot.data["address"]}, Nº${snapshot.data["number"]} - ${snapshot.data["neighborhood"]}", Icons.location_on, null),
              _listTileWidget("CEP",
                  "${snapshot.data["zipcode"]} / ${snapshot.data["uf"]}", Icons.map, null),
              _listTileWidget("Telefone", 
                  snapshot.data["phone"], Icons.phone, _openPhone(snapshot.data["phone"])),
              _listTileWidget("E-mail", 
                  snapshot.data["email"], Icons.alternate_email, _openEmail(snapshot.data["email"])),
            ],
          ),
          tapHeaderToExpand: true,
          hasIcon: true,
          initialExpanded: true),
    );
  }

  Widget _aboutUs() {
    return Card(
      elevation: 2.0,
      child: ExpandablePanel(
          header: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "SOBRE NÓS",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          expanded: Padding(
            padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: Text(snapshot.data["about"]),
          ),
          tapHeaderToExpand: true,
          hasIcon: true,
          initialExpanded: false),
    );
  }

  Widget _picutresEstablishment() {
    return Card(
      elevation: 2.0,
      child: ExpandablePanel(
          header: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "FOTOS DO LOCAL",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          expanded: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4.0),
                bottomRight: Radius.circular(4.0)),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Carousel(
                  images: snapshot.data["images"].map((url) {
                    return NetworkImage(url);
                  }).toList(),
                  dotSize: 4.0,
                  dotColor: Theme.of(context).primaryColor,
                  dotSpacing: 15.0,
                  dotBgColor: Colors.transparent,
                  autoplay: true),
            ),
          ),
          tapHeaderToExpand: true,
          hasIcon: true,
          initialExpanded: false),
    );
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
      child: ExpandablePanel(
          header: Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "LOCALIZAÇÃO",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          expanded: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4.0),
                bottomRight: Radius.circular(4.0)),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1,
              height: MediaQuery.of(context).size.height / 2.5,
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
          tapHeaderToExpand: true,
          hasIcon: true,
          initialExpanded: false),
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
              _aboutUs(),
              SizedBox(height: 4.0),
              _mapEstablishment(),
              SizedBox(height: 4.0),
              _picutresEstablishment(),
              SizedBox(height: 4.0),
            ],
          )),
    );
  }
}
