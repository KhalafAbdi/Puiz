import 'package:flutter/material.dart';
import 'package:pro/data/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro/model/game.dart';

class MultiPlayerGame extends StatefulWidget {
  final gameID;
  final owner;

  MultiPlayerGame({@required this.gameID, @required this.owner});

  @override
  _MultiPlayerGameState createState() => _MultiPlayerGameState();
}

class _MultiPlayerGameState extends State<MultiPlayerGame> {
  bool gameStarted = false;
  Game game;
  bool doneLoading = false;


  @override
  void initState() {
    super.initState();

    
    getGameInfo();
  }


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



  Future<bool> _onWillPop() {
    if(widget.owner == "true"){
      Database().deleteGame(widget.gameID);
    }else {
      print("wtf");
      game.state = "open";

      DocumentReference documentReference = Firestore.instance.collection('Games').document(widget.gameID);

      documentReference.updateData(game.toMap());
      print("updating date ${game.toMap()}");
    }
    
    Navigator.pop(context);
  }

  getGameInfo() async{
    DocumentReference documentReference = Firestore.instance.collection('Games').document(widget.gameID);
    DocumentSnapshot documentSnapshot = await documentReference.get();

      game = Game(
          documentSnapshot.documentID,
          documentSnapshot.data['category'],
          documentSnapshot.data['difficulty'],
          documentSnapshot.data['creatorID'],
          documentSnapshot.data['creatorName'],
          documentSnapshot.data['state'],
          documentSnapshot.data['password'],
      );

      doneLoading = true;
  }
}