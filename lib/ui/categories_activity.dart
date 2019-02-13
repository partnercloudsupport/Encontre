import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei/data/category_data.dart';
import 'package:encontrei/tile/establishment_tile.dart';
import 'package:flutter/material.dart';

class CategoriesActivity extends StatelessWidget {
  final CategoryData categoryData;
  final DocumentSnapshot snapshot;

  CategoriesActivity(this.categoryData, this.snapshot);

  Widget _showMessage(IconData icon, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 80.0,
              color: Colors.blue,
            ),
            Text(
              message,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget _loadEstablishment() {
    return FutureBuilder(
      future: Firestore.instance
          .collection("categories")
          .document(snapshot.documentID)
          .collection("establishment")
          .getDocuments(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return _showMessage(Icons.error, "Algo de errado aconteceu");
            } else {
              if (snapshot.data.documents.length > 0) {
                var dividedTiles = ListTile.divideTiles(
                        tiles: snapshot.data.documents.map<Widget>((doc) {
                          return EstablishmentTile(doc);
                        }).toList(),
                        color: Colors.grey[500])
                    .toList();
                return ListView(
                  children: dividedTiles,
                );
              } else {
                return _showMessage(
                    Icons.warning, "Nenhum estabelecimento cadastrado ainda");
              }
            }
            break;
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }

  Widget _appBarWithImage() {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: false,
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {})
              ],
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(categoryData.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Image.network(
                    categoryData.image,
                    fit: BoxFit.cover,
                  )),
            ),
          ];
        },
        body: _loadEstablishment(),
      ),
    );
  }

  Widget _appBarWithoutImage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryData.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 4.0), child: _loadEstablishment()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _appBarWithoutImage();
    //return _appBarWithImage();
  }
}
