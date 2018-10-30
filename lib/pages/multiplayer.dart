import 'package:flutter/material.dart';

class MultiplayerPage extends StatefulWidget {
  @override
  _MultiplayerPageState createState() => _MultiplayerPageState();
}

class _MultiplayerPageState extends State<MultiplayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Multiplayer Lobby"),
        automaticallyImplyLeading: false
      ),
      body: Text("List of Active games goes here"),
    );
  }
}