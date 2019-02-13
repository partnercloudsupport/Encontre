import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrei/data/category_data.dart';
import 'package:encontrei/ui/categories_activity.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final CategoryData categoryData;
  final DocumentSnapshot snapshot;

  CategoryTile(this.categoryData, this.snapshot);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CategoriesActivity(categoryData, snapshot)));
      },
      child: Card(
          child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          AspectRatio(
              aspectRatio: 1.0,
              child: Image.network(
                categoryData.image,
                fit: BoxFit.cover,
              )),
          Container(
            height: 25.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Color.fromARGB(180, 0, 0, 0)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                categoryData.title,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
