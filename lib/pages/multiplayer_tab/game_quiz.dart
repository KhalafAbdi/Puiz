import 'package:flutter/material.dart';
import 'package:pro/pages/multiplayer_tab/model/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro/model/game.dart';
import 'package:pro/model/user.dart';
import 'package:pro/data/database.dart';

import 'dart:ui';
import 'dart:async';

class GameQuiz extends StatefulWidget {
  final gameID;

  GameQuiz(this.gameID);

  @override
  _GameQuizState createState() => _GameQuizState();
}

class _GameQuizState extends State<GameQuiz> {
  bool isLoading = true;

  List<Question> questions = [];


  Game game;

  User user;
  User opponent;


  bool showAnswer = false;
  
  bool isCreator = false;

  int timeLeft;

  String statusMessage;

  @override
  void initState() {
    super.initState();

    setUp();
    timeLeft = 10;
  }

  Future<void> setUp() async {

    
    QuerySnapshot v = await Firestore.instance.collection('Messages').document(widget.gameID).collection("questions").getDocuments();
    DocumentSnapshot documentSnapshot = await Firestore.instance.collection('Games').document(widget.gameID).get();

    user = await Database().currentUser(); 
    print("joiner: " + documentSnapshot.data['joinerID']);
    print("joiner: " + documentSnapshot.data['creatorID']);
    
    
    if(user.displayName == documentSnapshot.data['creatorName']){
      opponent = await Database().getUser(documentSnapshot.data['joinerID']); 
      isCreator = true;
    }else {
      opponent = await Database().getUser(documentSnapshot.data['creatorID']); 
    }

    print("${user.displayName} has joined game started by ${documentSnapshot.data['creatorName']}");
    
    
    print("username: " + user.to());
    print("opponent: " + opponent.to());

    for (DocumentSnapshot item in v.documents) {
      
      List<String> list = [];
      list.addAll(item.data['incorrectAnswers'].cast<String>());

      Question question = new Question(
        question: item.data['question'],
        correctAnswer: item.data['correctAnswer'],
        incorrectAnswers: list
      );

      questions.add(question);
    }

    game = Game.start(
      documentSnapshot.documentID,
      documentSnapshot.data['category'],
      documentSnapshot.data['difficulty'],
      documentSnapshot.data['creatorID'],
      documentSnapshot.data['creatorName'],
      documentSnapshot.data['state'],
      documentSnapshot.data['joinerID'],
      documentSnapshot.data['joinerName'],
    );



    setState(() {
      isLoading = false;
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        gameHasStarted = true;
      });

    });
  }



  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.red,
        child: !isLoading ? questionList() : Container(child: Center(child: CircularProgressIndicator()))
    );
  }

  bool gameHasStarted = false;

  Widget questionList(){
    return Container(
      child: Stack(
        children: <Widget>[
          quiz(),
          
          (!gameHasStarted) ? blur() : Container(),
          (!gameHasStarted) ? startScreen() : Container()
        ],
      ),
    );
  }

  Widget blur(){
    return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.0),
            ),
          );
  }

List<String> allAnswers = [];

Widget quiz() {
  

  

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[ 
        questionStream()
      ]
    );
  }

  Widget questionStream(){

    return StreamBuilder(
      stream: Firestore.instance.collection('Messages').document(widget.gameID).snapshots(),
      builder: (context, snap) {
        if(!snap.hasData){
          return Text("");
        }

          return placeholder(snap.data['currentquestion']);
        

        },
    ); 
  }

  Widget placeholder(int index){
    if(allAnswers != null) allAnswers.clear();

    allAnswers.addAll(questions[index-1].incorrectAnswers);
    allAnswers.add(questions[index-1].correctAnswer);
   allAnswers.shuffle();


    return Container(
        margin: EdgeInsets.only(top: 40.0, left: 15.0, right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            scoreBoardStream(),

             new Container(
              margin: EdgeInsets.only(bottom: 2.0, top: 5.0),
              alignment: Alignment.centerRight,
              child: new Text("Question $index of ${questions.length}",
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w300))
            ),

            Card(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top:5.0),
                  alignment: Alignment.center,
                  child: Text(game.category,
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0)),
                ),
                Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
                        child: Text(questions[index-1].question,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xcc2c304d))),
                      ),
                Container(
                  height: 25.0,
                  color: Colors.black.withAlpha(10),
                  child: Center(
                    child: Text("$timeLeft seconds"),
                  ),
                )
              ],
            )),

            Container(
              margin: EdgeInsets.only(top:0.0),
              child: Column(
                children: <Widget>[
                  answerStream(index-1)
                ],
              ),
            )

          ],
        ),
      );
  }





  Widget answerStream(int currenQuestionIndex){
    String questionPath = 'question_${currenQuestionIndex+1}';

    return StreamBuilder(
      stream: Firestore.instance.collection('Messages').document(widget.gameID).collection('questions').document(questionPath).snapshots(),
      builder: (context, snap) {
        if(!snap.hasData){
          return Text("");
        }

        return answerCardsList(snap.data['ownerAnswer'], snap.data['joinerAnswer'], currenQuestionIndex);

        },
    );
  }


  Widget answerCardsList(String ownerAnswer, String joinerAnswer,int currenQuestionIndex){
    String ownAnswer;
    String opponentAnswer;

    if(isCreator){
      ownAnswer = ownerAnswer;
      opponentAnswer = joinerAnswer;
    }else {
      ownAnswer = joinerAnswer;
      opponentAnswer = ownerAnswer;
    }
    
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: allAnswers.length,
      itemBuilder: (BuildContext context, int index) {
        return answerWidget(allAnswers[index], ownAnswer, opponentAnswer, showAnswer, currenQuestionIndex);
      }
    );
  }
   
  Widget answerWidget(String answer, String ownAnswer, String opponentAnswer, bool showAnswer, int currenQuestionIndex){
    return Stack(
      children: <Widget>[
        Card(
          color: answer == questions[currenQuestionIndex].correctAnswer && showAnswer ? Colors.greenAccent : Colors.white,
          margin: EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: <Widget>[
              ListTile(
            enabled: true,
            onTap: () => pressedAnswer(answer, ownAnswer, opponentAnswer, currenQuestionIndex),
            title: Text(
              answer,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xcc2c304d),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
            ],
          )
        ),

        Container(
        padding: EdgeInsets.only(top: 2.0, left: 25.0, right: 25.0),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Opacity(
            opacity: (ownAnswer == answer)? 1.0 : 0.0,
            child: const Text('You'),
          ),
          Opacity(
            opacity: (opponentAnswer == answer)? 1.0 : 0.0,
            child: const Text('Adapt'),
          ),
        ],
      ),
      )
      ],
    );
  }

  pressedAnswer(String answer, String ownAnswer, String opponentAnswer, int currenQuestionIndex) async {
    print("Pressed $answer - fecthing database");

    Question q = Question(
      question: questions[currenQuestionIndex].question,
      correctAnswer: questions[currenQuestionIndex].correctAnswer,
      incorrectAnswers: questions[currenQuestionIndex].incorrectAnswers
    );

    String temp1; 
    String temp2;

    if(isCreator){
      temp1 = answer;
      temp2 = opponentAnswer;
    }else {
      temp1 = opponentAnswer;
      temp2 = answer;
    }

    print("Updating database");
    Firestore.instance.collection('Messages').document(widget.gameID).collection('questions').document('question_${currenQuestionIndex+1}').setData(q.toNewMap(temp1, temp2));

  }

  Widget scoreBoardStream(){
    return StreamBuilder(
      stream: Firestore.instance.collection('Messages').document(widget.gameID).snapshots(),
      builder: (context, snap) {
        if(!snap.hasData){
          return Text("");
        }
          return scoreBoard(snap.data['creatorscore'], snap.data['joinerscore'],);                     
        },
    );
  }

  Widget scoreBoard(int creatorScore, int joinerScore){
    
    int ownScore = isCreator ? creatorScore : joinerScore;
    int opponentScore = isCreator ? joinerScore : creatorScore;

    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("You",
                      style: TextStyle(
                      fontSize: (ownScore < opponentScore) ? 13.0 : 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300)),
                    Text(ownScore.toString(),
                      style: TextStyle(
                      fontSize: (ownScore < opponentScore) ? 18.0 : 28.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300)),
                  ],
                ),

                Column(
                  children: <Widget>[
                    Text(opponent.displayName,
                      style: TextStyle(
                      fontSize: (ownScore > opponentScore) ? 13.0 : 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300)),
                    Text(opponentScore.toString(),
                      style: TextStyle(
                      fontSize: (ownScore > opponentScore) ? 18.0 : 28.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300)),
                  ],
                ),
              ],
            );
  }

  
























  Widget startScreen(){
    return Stack(
        children: <Widget>[
          playerStatsScreen(),
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 50.0),
              child: Text("VS",
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
                ),
          )
        ],
      );
  }


  Widget playerStatsScreen(){
    return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom:25.0),
                            width: 150.0,
                            height: 150.0,
                            decoration: new BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(user.displayName, style: TextStyle(fontSize: 18.0, color: Colors.redAccent),),
                          Text("Level " + user.level.toString(), style: TextStyle(fontSize: 11.0, color: Colors.greenAccent),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom:25.0),
                            width: 150.0,
                            height: 150.0,
                            decoration: new BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(opponent.displayName, style: TextStyle(fontSize: 18.0, color: Colors.redAccent),),
                          Text("Level " + opponent.level.toString(), style: TextStyle(fontSize: 11.0, color: Colors.greenAccent),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}

