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

  Widget currentWidget;


  @override
  void initState() {
    super.initState();

    currentWidget = lobbyWidget();
    getGameInfo();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: currentWidget
      ),
    );
  }

  Widget us(String s){
    return Container(
      child: s == "" ? Text("1") : Text("2"),
    );
  }


  Widget lobbyWidget(){
    return Container(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("This is multiplayer game: ${widget.gameID}"),
            widget.owner == "true" ?
              StreamBuilder(
                stream:  Firestore.instance.collection('Games').document(widget.gameID).snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) {
                    return const Text("Loading...");
                  }else {
                    return us(snapshot.data['joiner'].toString());
                  }
                    
                  
                },
              )
              :
              Text("Joiner")
          ],
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
  }
}