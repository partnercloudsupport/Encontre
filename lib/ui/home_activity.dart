import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei/data/category_data.dart';
import 'package:encontrei/tile/category_tile.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class HomeActivity extends StatefulWidget {
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  Widget _topTexts(String text, FontWeight fontWeight, double fontSize) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: fontWeight, color: Colors.white, fontSize: fontSize),
    );
  }

  Widget _carouselImage() {
    return Carousel(
      images: [
        NetworkImage(
            "https://scontent.fpoa6-1.fna.fbcdn.net/v/t1.0-9/30226182_1670722086337822_2924877442096113084_n.png?_nc_cat=110&_nc_ht=scontent.fpoa6-1.fna&oh=2f62a50285734e39294a3a74234ac16e&oe=5CE52392"),
        NetworkImage(
            "https://scontent.fpoa6-1.fna.fbcdn.net/v/t1.0-9/26903783_1593708934039138_8456771874017279377_n.png?_nc_cat=101&_nc_ht=scontent.fpoa6-1.fna&oh=ad0c296f264a76e58e7949e0198d9f5c&oe=5CE0CAF7"),
        NetworkImage(
            "https://scontent.fpoa6-1.fna.fbcdn.net/v/t1.0-9/26907124_1595705960506102_7934089022868189376_n.png?_nc_cat=108&_nc_ht=scontent.fpoa6-1.fna&oh=38d9c909e94b7120ad8f48ae0e0f195e&oe=5CFCC64E"),
        NetworkImage(
            "https://scontent.fpoa6-1.fna.fbcdn.net/v/t1.0-9/19366442_1387132248030142_4984394172633788887_n.png?_nc_cat=108&_nc_ht=scontent.fpoa6-1.fna&oh=8633738a3de5e8039a92c4a4da111667&oe=5CE7431B"),
      ],
      dotSize: 5.0,
      dotColor: Theme.of(context).primaryColor,
      dotSpacing: 15.0,
      dotBgColor: Colors.transparent,
      autoplay: true,
      borderRadius: true,
      radius: Radius.circular(20.0),
    );
  }

  Widget _cardCarouselImages() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
      child: Card(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 3,
            child: _carouselImage()),
      ),
    );
  }

  Widget _roundedContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0))),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _topTexts("Bem Vindo à Camaquã", FontWeight.w700, 20.0),
          _topTexts(
              "Encontramos 20 serviços para você", FontWeight.normal, 12.0),
        ],
      )),
    );
  }

  Widget _categories() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text("Categorias",
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue)),
        )
      ],
    );
  }

  Widget _sliverHeader() {
    return SliverList(
        delegate: SliverChildListDelegate([
      Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          _roundedContainer(),
          _cardCarouselImages(),
        ],
      ),
    ]));
  }

  Widget _sliverCategory() {
    return SliverList(
        delegate: SliverChildListDelegate([
      _categories(),
    ]));
  }

  Widget _sliverGridCategory() {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("categories").getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverList(
              delegate: SliverChildListDelegate([
            Center(
              child: CircularProgressIndicator(),
            )
          ]));
        } else {
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4.0,
                childAspectRatio: 1.0,
                crossAxisSpacing: 4.0),
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return CategoryTile(
                  CategoryData.fromDocument(snapshot.data.documents[index]),
                  snapshot.data.documents[index]);
            }, childCount: snapshot.data.documents.length),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        _sliverHeader(),
        _sliverCategory(),
        _sliverGridCategory()
      ],
    ));
  }
}
