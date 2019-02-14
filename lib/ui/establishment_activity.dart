import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EstablishmentActivity extends StatefulWidget {
  final DocumentSnapshot snapshot;

  EstablishmentActivity(this.snapshot);

  @override
  _EstablishmentActivityState createState() =>
      _EstablishmentActivityState(snapshot);
}

class _EstablishmentActivityState extends State<EstablishmentActivity> {
  final DocumentSnapshot snapshot;

  _EstablishmentActivityState(this.snapshot);

  GoogleMapController mapController;

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

  Widget _listData() {
    return Column(
      children: <Widget>[
        _listTileWidget(
            "Endereço", snapshot.data["address"], Icons.location_on),
        _listTileWidget("Número", snapshot.data["number"], Icons.looks_one),
        _listTileWidget(
            "Bairro", snapshot.data["neighborhood"], Icons.device_hub),
        _listTileWidget("CEP", snapshot.data["zipcode"], Icons.map),
        _listTileWidget("UF", snapshot.data["uf"], Icons.account_balance),
        _listTileWidget("Telefone", snapshot.data["phone"], Icons.phone),
        _listTileWidget(
            "E-mail", snapshot.data["email"], Icons.alternate_email),
      ],
    );
  }

  Widget _establishmentData() {
    return Card(
      elevation: 2.0,
      child: _listData(),
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

  Widget _appBarWithoutCarousel() {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrooled) {
            return <Widget>[_appBar()];
          },
          body: ListView(
            padding: EdgeInsets.all(12.0),
            children: <Widget>[
              _establishmentData(),
              SizedBox(height: 4.0),
              _mapEstablishment()
            ],
          )),
    );
  }

  Widget _carouselImages() {
    AspectRatio(
      aspectRatio: 0.9,
      child: Carousel(
          images: snapshot.data["images"].map((url) {
            return NetworkImage(url);
          }).toList(),
          dotSize: 4.0,
          dotColor: Colors.blue,
          dotSpacing: 15.0,
          dotBgColor: Colors.transparent,
          autoplay: false),
    );
  }

  Widget _appBarWithCarousel() {
    return Scaffold(
      appBar: AppBar(
        title: Text(snapshot.data["title"]),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          _carouselImages(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _appBarWithoutCarousel();
  }
}
