import 'package:flutter/material.dart';
import 'package:pro/data/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro/model/game.dart';
import 'package:pro/pages/multiplayer_tab/model/chatmessage.dart';
import 'package:pro/data/constants.dart' as constants;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pro/pages/multiplayer_tab/model/question.dart';
import 'game_quiz.dart';

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
            stream: Firestore.instance.collection('Games').document(widget.gameID).snapshots(),
             builder: (context, snap) {
              if(!snap.hasData){
                return Text("");
              }

              if(snap.data['state'] == "open" || snap.data['state'] == "closed"){
                return chat();
              }else if(snap.data['state'] == "started") {
                gameStarted = true;
                return MultiPlayerQuiz();
              }

              return Text("Something is horriably wrong");

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
                future: Database().currentUser(),
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
                Column(
                  children: <Widget>[
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: FutureBuilder(
                        future: Firestore.instance.collection('Games').document(widget.gameID).get(),
                        builder: (context, snap) {
                          if(!snap.hasData){
                            return Text("");
                          }
                          return Text(snap.data['creatorName'],
                          style: TextStyle(
                          fontSize: 14.5,
                          color: Colors.black,
                          fontWeight: FontWeight.w500));
                        },
                      )
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text("V S",
                    style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w700)),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: StreamBuilder(
                        stream: Firestore.instance.collection('Games').document(widget.gameID).snapshots(),
                        builder: (context, snap) {
                          if(!snap.hasData){
                            return Text("");
                          }

                          String text = (snap.data['joinerName'] == "") ? "waiting" : snap.data['joinerName'];
                          
                          
                          
                          return Text(text,
                          style: TextStyle(
                          fontSize: 14.5,
                          color: Colors.black,
                          fontWeight: FontWeight.w500));
                        },
                      )
                    )
                  ],
                ),
              ],
            ), Container(
              margin: EdgeInsets.only(top: 15.0),
              child:  StreamBuilder(
                        stream: Firestore.instance.collection('Games').document(widget.gameID).snapshots(),
                        builder: (context, snap) {
                          if(!snap.hasData){
                            return Text("");
                          }

                          String btnText = (snap.data['joinerName'] == "") ? "Waiting for opponent..." : "Start";
                          
                          return new RaisedButton(
                                                  
                          child: Text(btnText),

                            onPressed: btnText!="Start" ? null : () {

                              game.state = "started";
                              game.joinerID = snap.data['joinerID'];
                              game.joinerName = snap.data['joinerName'];

                              DocumentReference documentReference = Firestore.instance.collection('Games').document(widget.gameID);

                              documentReference.updateData(game.toMap());
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


  Widget chatScreen(){
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Flexible(
              child: StreamBuilder(
                stream: Firestore.instance.collection('Messages').document(widget.gameID).collection("messages").snapshots(),
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
    for (DocumentSnapshot doc in snap.data.documents) {
      temporalList.add(ChatMessage(
          content: doc['content'],
          name: doc['sender'],
          senderID: doc['senderID']
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


  void _handleSubmit(String text) {
    _chatController.clear();
      ChatMessage message = new ChatMessage(
        content: text,
        name: game.creatorName,
        senderID: game.creatorID
    );
      
    Firestore.instance.collection('Messages').document(widget.gameID).collection("messages").add(message.toMap());
    print("Attempt to update database");
}






  setupGame() async{
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
    responseCode = json['response_code'];
    if (json['results'] != null) {

      for (var i = 0; i < json['results'].length; i++) {
        Results res = Results.fromJson(json['results'][i]);

        Question question = Question(
            question: res.question,
            correctAnswer: res.correctAnswer,
            incorrectAnswers: res.incorrectAnswers
        );

        Firestore.instance.collection('Messages').document(widget.gameID).collection("questions").document("question_${i+1}").setData(question.toMap());
      }
    }
  }






  Future<bool> _onWillPop() {
    if(!gameStarted){
      if(widget.owner == "true"){
        Database().deleteGame(widget.gameID);
      }else {
        print("wtf");
        game.state = "open";
        game.joinerID = "";
        game.joinerName = "";


        DocumentReference documentReference = Firestore.instance.collection('Games').document(widget.gameID);

        documentReference.updateData(game.toMap());
        print("updating date ${game.toMap()}");
      }
      
      Navigator.pop(context);
    }else {
      print("you are quiting the game");

      Navigator.pop(context);
    }

    
  }

}


class Results {
  String category;
  String type;
  String difficulty;
  String question;
  String correctAnswer;
  List<String> incorrectAnswers;

  Results({
    this.category,
    this.type,
    this.difficulty,
    this.question,
    this.correctAnswer,
  });

  Results.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    type = json['type'];
    difficulty = json['difficulty'];
    question = json['question'];
    correctAnswer = json['correct_answer'];
    incorrectAnswers = json['incorrect_answers'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['type'] = this.type;
    data['difficulty'] = this.difficulty;
    data['question'] = this.question;
    data['correct_answer'] = this.correctAnswer;
    data['incorrect_answers'] = this.incorrectAnswers;
    return data;
  }
}
