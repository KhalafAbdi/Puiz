import 'package:flutter/material.dart';
import 'package:pro/data/database.dart';

class MultiPlayerGame extends StatefulWidget {
  final gameID;

  MultiPlayerGame({@required this.gameID});

  @override
  _MultiPlayerGameState createState() => _MultiPlayerGameState();
}

class _MultiPlayerGameState extends State<MultiPlayerGame> {
  bool gameStarted = false;


  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Container(
        padding: EdgeInsets.all(25.0),
        child: Text("This is multiplayer game: ${widget.gameID}"),
        ),
      ),
    );
  }



  Future<bool> _onWillPop() async{
    Database().deleteGame(widget.gameID);
    Navigator.pop(context);
  }
}