import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei/utils/utils_launch.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
          onPressed: () {
            _showSnackbar(
                "Nenhum cupom disponível no momento, tente mais tarde!",
                Colors.green,
                3);
          },
        )
      ],
    );
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
              ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(
                  Icons.location_on,
                  color: Colors.blue,
                ),
                onTap: () {
                  UtilsLaunch.openMaps(
                      "https://maps.google.com/?q=${snapshot.data["title"]}&ll=${snapshot.data["lat"]},${snapshot.data["lon"]}");
                },
                title: Text("Endereço"),
                subtitle: Text(
                    "${snapshot.data["address"]}, Nº${snapshot.data["number"]} - ${snapshot.data["neighborhood"]} - ${snapshot.data["zipcode"]} / ${snapshot.data["uf"]}"),
              ),
              ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(
                  Icons.phone,
                  color: Colors.blue,
                ),
                title: Text("Telefone"),
                onTap: () {
                  UtilsLaunch.openPhone(snapshot.data["phone"]);
                },
                subtitle: Text(snapshot.data["phone"]),
              ),
              ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(
                  Icons.alternate_email,
                  color: Colors.blue,
                ),
                title: Text("E-mail"),
                onTap: () {
                  UtilsLaunch.openEmail(snapshot.data["email"]);
                },
                subtitle: Text(snapshot.data["email"]),
              ),
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

  Widget _picturesEstablishment() {
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

  void _showSnackbar(String text, Color color, int seconds) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      duration: Duration(seconds: seconds),
    ));
  }

  @override
  Widget build(BuildContext context) {
    /* var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      backgroundColor: Colors.blue[500],
      mini: true,
      child: Icon(Icons.share),
      onPressed: () {},
    )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            onPressed: () {
              UtilsLaunch.openFacebook(
                  "https://www.facebook.com/${snapshot.data["facebook"]}");
            },
            backgroundColor: Color.fromARGB(255, 59, 89, 152),
            mini: true,
            child: Image.asset("assets/facebook.png", width: 24))));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            onPressed: () {
              UtilsLaunch.openWhatsApp(
                  "https://api.whatsapp.com/send?phone=${snapshot.data["whatsapp"]}");
            },
            backgroundColor: Color.fromARGB(255, 52, 175, 35),
            mini: true,
            child: Image.asset("assets/whatsapp.png", width: 24))));*/

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Center(
              child: Container(
                width: 24.0,
                height: 24.0,
                child: Image.asset("assets/share.png", width: 24),
              ),
            ),
            backgroundColor: Colors.blue[500],
            onTap: () => _showSnackbar("Em Breve!", Colors.blue[500], 3),
          ),
          SpeedDialChild(
            child: Center(
              child: Container(
                width: 24.0,
                height: 24.0,
                child: Image.asset("assets/facebook.png", width: 24),
              ),
            ),
            backgroundColor: Color.fromARGB(255, 59, 89, 152),
            onTap: () => UtilsLaunch.openFacebook(
                  "https://www.facebook.com/${snapshot.data["facebook"]}"),
          ),
          SpeedDialChild(
            child: Center(
              child: Container(
                width: 24.0,
                height: 24.0,
                child: Image.asset("assets/whatsapp.png", width: 24),
              ),
            ),
            backgroundColor: Color.fromARGB(255, 52, 175, 35),
            onTap: () => UtilsLaunch.openWhatsApp(
                "https://api.whatsapp.com/send?phone=${snapshot.data["whatsapp"]}"),
          ),
        ],
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
              _picturesEstablishment(),
              SizedBox(height: 4.0),
            ],
          )),
    );
  }
}
