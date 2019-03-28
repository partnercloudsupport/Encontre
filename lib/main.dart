import 'package:encontrei/ui/home_activity.dart';
import 'package:flutter/material.dart';

void main() => runApp(Encontrei());

class Encontrei extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Encontrei - Camaquã",
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 41, 98, 255),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeActivity(),
    );
  }
}
