import 'package:flutter/material.dart';

class DeathMatchPage extends StatefulWidget {
  @override
  _DeathMatchPageState createState() => _DeathMatchPageState();
}

class _DeathMatchPageState extends State<DeathMatchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("DeathMatch"),
        automaticallyImplyLeading: false
      ),
      body: Text("Death Match games here"),
    );
  }
}