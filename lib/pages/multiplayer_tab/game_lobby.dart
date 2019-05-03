import 'package:flutter/material.dart';
import 'package:pro/data/database.dart';
import 'package:pro/model/game.dart';
import 'package:pro/model/chatmessage.dart';
import 'package:pro/data/constants.dart' as constants;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pro/model/question.dart';
import 'game_quiz.dart';
import 'package:pro/model/user.dart';

import 'package:pro/model/ApiRequestResult.dart';

class GameLobby extends StatefulWidget {
  final gameID;
  final owner;

  GameLobby({@required this.gameID, @required this.owner});

  @override
  _GameLobbyState createState() => _GameLobbyState();
}

class _GameLobbyState extends State<GameLobby> {
  final TextEditingController _chatController = new TextEditingController();
  List<ChatMessage> _messages = <ChatMessage>[];

  bool gameStarted = false;

  Game game;


  @override
  void initState() {
    super.initState();

    setupGame();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          resizeToAvoidBottomPadding: true,
          body: StreamBuilder(
            stream: Database().getCurrentGameFields(widget.gameID),
             builder: (context, snap) {
              if(!snap.hasData){
                return Text("");
              }



              if(snap.data[constants.gameState].toString() == constants.gameStateOpen || snap.data[constants.gameState].toString() == constants.gameStateClosed){
                return chat();
              }else if(snap.data[constants.gameState] == constants.gameStateStarted) {
                gameStarted = true;
                return GameQuiz(widget.gameID);
              }

              return Center(child: Text("Something is horriably wrong state:" + snap.data[constants.gameState].toString()));

            },
          )
        )
      ),
    );
  }

  Widget chat(){
    return Column(
            children: <Widget>[
              topPart(),
              Flexible(
                    child: FutureBuilder(
                future: Database().getCurrentUserData(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return Text("Loading");
                  }else {
                    return chatScreen();
                  }
                },
              ),
              )
            ],
          );
  }

  Widget quiz(){
    return Container(
      color: Colors.red,
      child: Text("QUIZ"),
    );
  }

  Widget topPart(){
    return Column(
      children: <Widget>[
        new Container(
          decoration: 
          new BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: Container(
            margin: EdgeInsets.only(top: 30.0),
            padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                children: <Widget>[
                  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 FutureBuilder(
                  future: Database().getGame(widget.gameID),
                  builder: (context, snap) {
                    if(!snap.hasData){
                      return CircularProgressIndicator();
                    }

                    
                    

                    return Column(
                    children: <Widget>[
                      FutureBuilder(
                          future: Database().getUserDocument(snap.data[constants.gameCreatorID].toString()),
                          builder: (context, snap) {
                            if(!snap.hasData){
                              
                              return Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red
                              )
                            );

                            }



                            return Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(snap.data[constants.userImgPath])
                            )
                            ),
                          );

                          },

                        ),
                      Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: Text(snap.data[constants.gameCreatorName],
                            style: TextStyle(
                            fontSize: 14.5,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)) 
                      )
                    ],
                  );

                  }),
                /*
                
                */
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text("V S",
                    style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w700)),
                ),

                StreamBuilder(
                  stream: Database().getCurrentGameFields(widget.gameID),
                  builder: (context, snap) {
                    if(!snap.hasData){
                      return CircularProgressIndicator();
                    }

                    String text = (snap.data[constants.gameJoinerName] == "") ? "waiting" : snap.data[constants.gameJoinerName];

                    return Column(
                      children: <Widget>[
                        FutureBuilder(
                          future: Database().getUserDocument(snap.data[constants.gameJoinerID]),
                          builder: (context, snap) {
                            if(!snap.hasData){
                              return Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black26
                              ));
                            }

                            bool hasJoiner = (snap.data[constants.gameJoinerName] != "" && snap.data[constants.gameJoinerName] != null);


                            print("Joined : $hasJoiner");


                            return Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(snap.data[constants.userImgPath])
                            )
                            ) 
                            
                            

                          );

                          },

                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Text(text,
                              style: TextStyle(
                              fontSize: 14.5,
                              color: Colors.black,
                              fontWeight: FontWeight.w500))
                            ,
                          
                        )
                      ],
                    );
                  }
                ),
                
              ],
            ), Container(
              margin: EdgeInsets.only(top: 15.0),
              child:  StreamBuilder(
                        stream: Database().getCurrentGameFields(widget.gameID),
                        builder: (context, snap) {
                          if(!snap.hasData){
                            return Text("");
                          }

                          String btnText = (snap.data[constants.gameJoinerName] == "") ? "Waiting for opponent..." : "Start";
                          
                          return new RaisedButton(
                                                  
                          child: Text(btnText),

                            onPressed: (btnText !="Start" && widget.owner == "true") ? null : () {

                              game.state = constants.gameStateStarted;
                              game.joinerID = snap.data[constants.gameJoinerID];
                              game.joinerName = snap.data[constants.gameJoinerName];

                              Database().updateGame(widget.gameID, game);
                              print("Start Game");
                            }
                          );
                        },
                      )
              )
                ],
              ),
          ),
        ),
        new Divider(
          height: 1.0,
        ),
      ],
    );
  }

  getImgPath(String userID) async {
    User u = await Database().getUser(userID);

    return u.imgPath;
  }

  Widget chatScreen(){
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Flexible(
              child: StreamBuilder(
                stream: Database().getCurrentGameChatMessages(widget.gameID),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return Text("");
                  }else {
                    updateList(snapshot);

                    return ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) => _messages[(_messages.length-1)-index],
                      itemCount: _messages.length,
                    );
                  }
                },
              ),
            ),
            new Divider(
              height: 1.0,
            ),
            new Container(decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _chatEnvironment(),)
          ],
        );
  }

  updateList(AsyncSnapshot snap){
    _messages = <ChatMessage>[];
    var temporalList = List<ChatMessage>();
    for (var doc in snap.data.documents) {
      temporalList.add(ChatMessage(
          content: doc[constants.messageContent],
          name: doc[constants.messageSender],
          senderID: doc[constants.messagSenderID],
          avatar: doc[constants.messageAvatar],
        )
      );
    }
    
    _messages.addAll(temporalList);
    
      

  }


  Widget _chatEnvironment (){
    return IconTheme(
      data: new IconThemeData(color: Colors.blue),
          child: new Container(
        margin: const EdgeInsets.symmetric(horizontal:8.0),
        child: new Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                  decoration: new InputDecoration.collapsed(hintText: "Start typing ..."),
                  controller: _chatController,
                  onSubmitted: _handleSubmit,
                ),
            ),
            
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                
                onPressed: ()=> _handleSubmit(_chatController.text),
                 
              ),
            )
          ],
        ),

      ),
    );
  }


  void _handleSubmit(String text) async{
    User user = await Database().getCurrentUserData();

    _chatController.clear();
      ChatMessage message = new ChatMessage(
        content: text,
        name: game.creatorName,
        senderID: game.creatorID,
        avatar: user.imgPath,
    );
      
    Database().addMessage(widget.gameID, message);
}






  setupGame() async{

    game = await Database().buildandReturnGame(widget.gameID);
    
    String link = "https://opentdb.com/api.php?amount=5&category=${constants.subjects[game.category]}&difficulty=${game.difficulty}&type=multiple";
    if(widget.owner == "true"){
      fetchQuestions(link);
    }
  }

  Future<void> fetchQuestions(String link) async {
    var res = await http.get(link);
    var decRes = jsonDecode(res.body);
    print(decRes);

    fromJson(decRes);
  }
  
  int responseCode;

  fromJson(Map<String, dynamic> json) {
    responseCode = json[constants.responseCode];
    if (json[constants.responseResult] != null) {

      for (var i = 0; i < json[constants.responseResult].length; i++) {
        Results res = Results.fromJson(json[constants.responseResult][i], useAllAnswers: false);

        Question question = Question(
            question: res.question,
            correctAnswer: res.correctAnswer,
            incorrectAnswers: res.incorrectAnswers
        );

        Database().createQuestions(widget.gameID, question, i);
      }
    }

    var map = new Map<String, dynamic>();
    map[constants.gameJoinerScore] = 0;
    map[constants.gameCreatorScore] = 0;
    map[constants.gameCurrentRound] = 1;
    
    Database().setGameFields(widget.gameID, map);

  }



  Future<bool> _onWillPop() {
    if(!gameStarted){
      if(widget.owner == "true"){
        Database().deleteGame(widget.gameID);
      }else {
        game.state = constants.gameStateOpen;
        game.joinerID = "";
        game.joinerName = "";

        Database().updateGame(widget.gameID, game);

        print("updating date ${game.toMap()}");
      }
      
      Navigator.pop(context);
    }else {

      //TODO: warn user that they are about to leave the game
      Navigator.pop(context);
    }

    
  }

}


