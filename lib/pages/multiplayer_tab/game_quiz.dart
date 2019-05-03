import 'package:flutter/material.dart';
import 'package:pro/model/question.dart';
import 'package:pro/model/game.dart';
import 'package:pro/model/user.dart';
import 'package:pro/data/database.dart';

import 'package:html_unescape/html_unescape.dart';
import 'dart:ui';
import 'dart:async';

import 'package:pro/data/constants.dart' as constants;

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

  User player;
  User opponent;

  var unescape = new HtmlUnescape();

  bool showAnswer = false;
  bool isCreator = false;
  int timeLeft;

  String statusMessage;

  @override
  void initState() {
    super.initState();

    setUp();
    timeLeft = 10; //TODO: use time
  }

  Future<void> setUp() async {

    await Database().setUpGame(widget.gameID);
    player = await Database().getPlayer();
    opponent = await Database().getOpponent(widget.gameID);
    isCreator = await Database().getIsCreator();

    questions = await Database().getQuestions(widget.gameID);
    game = await Database().getCurrentGame(widget.gameID);
    
    setState(() {
      isLoading = false;
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
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
      stream: Database().getCurrentGameStats(widget.gameID),
      builder: (context, snap) {
        if(!snap.hasData){
          return Text("");
        }
          if(snap.data[constants.gameCurrentRound] <= 5){
            return placeholder(snap.data[constants.gameCurrentRound]);
          }else {
            return Container(
              child: Text("Game Has ended"), //TODO: Score for each player
            );
          }
          
        

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
                        child: Text(unescape.convert(questions[index-1].question),
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
    return StreamBuilder(
      stream: Database().getQuestionInCurrentGame(widget.gameID, currenQuestionIndex),
      builder: (context, snap) {
        if(!snap.hasData){
          return Text("");
        }

        return answerCardsList(snap.data[constants.gameOwnerAnswer], snap.data[constants.gameJoinerAnswer], currenQuestionIndex, snap.data[constants.gameJoinerAnswerTime], snap.data[constants.gameOwnerAnswerTime]);

        },
    );
  }


  Widget answerCardsList(String ownerAnswer, String joinerAnswer,int currenQuestionIndex, int joinerAnswerTime, int ownerAnswerTime){
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
        return answerWidget(allAnswers[index], ownAnswer, opponentAnswer, showAnswer, currenQuestionIndex, joinerAnswerTime, ownerAnswerTime);
      }
    );
  }
   
  Widget answerWidget(String answer, String ownAnswer, String opponentAnswer, bool showAnswer, int currenQuestionIndex, int joinerAnswerTime, int ownerAnswerTime){
    return Stack(
      children: <Widget>[
        Card(
          color: answer == questions[currenQuestionIndex].correctAnswer && showAnswer ? Colors.greenAccent : Colors.white,
          margin: EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: <Widget>[
              ListTile(
            enabled: true,
            onTap: () => pressedAnswer(answer, ownAnswer, opponentAnswer, currenQuestionIndex, joinerAnswerTime, ownerAnswerTime),
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
            child: const Text('Opponent'),
          ),
        ],
      ),
      )
      ],
    );
  }

  pressedAnswer(String answer, String ownAnswer, String opponentAnswer, int currenQuestionIndex, int joinerAnswerTime, int ownerAnswerTime) async {
    print("--------------------------Pressed $answer - fecthing database-----------------------");

    print("ownAnswer: " + answer);
    print("opponentAnswer: " + opponentAnswer);


    Question q = Question.answer(
      question: questions[currenQuestionIndex].question,
      correctAnswer: questions[currenQuestionIndex].correctAnswer,
      incorrectAnswers: questions[currenQuestionIndex].incorrectAnswers,

      ownerAnswer: (isCreator) ? answer : opponentAnswer,
      ownerAnswertime : (isCreator) ? DateTime.now().millisecondsSinceEpoch : ownerAnswerTime,

      joinerAnswer: (isCreator) ? opponentAnswer : answer,
      joinerAnswertime : (isCreator) ? joinerAnswerTime : DateTime.now().millisecondsSinceEpoch,
    );

    Database().updateGameData(widget.gameID, currenQuestionIndex, q);

  }

  Widget scoreBoardStream(){
    return StreamBuilder(
      stream: Database().getCurrentGameStats(widget.gameID),
      builder: (context, snap) {
        if(!snap.hasData){
          return Text("");
        }
          return scoreBoard(snap.data[constants.gameCreatorScore], snap.data[constants.gameJoinerScore],);                     
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
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(player.imgPath)
                            )
                            
                            ),
                          ),
                          Text(player.displayName, style: TextStyle(fontSize: 18.0, color: Colors.redAccent),),
                          Text("Level " + player.level.toString(), style: TextStyle(fontSize: 11.0, color: Colors.greenAccent),)
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
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(opponent.imgPath)
                            )
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

