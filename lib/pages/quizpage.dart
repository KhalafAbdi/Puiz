import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pro/config/application.dart';
import 'package:http/http.dart' as http;
import 'package:pro/data/database.dart';
import 'package:pro/model/user.dart';
import 'package:html_unescape/html_unescape.dart';

class QuizPage extends StatefulWidget {
  final subject;

  QuizPage({@required this.subject}){
    print("I have been summoned with this $subject");
  }

  

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  var subjects = {
    'Any Category': null, //https://opentdb.com/api.php?amount=1
    'General Knowledge': 9, //https://opentdb.com/api.php?amount=1&category=9
    'Books': 10,
    'Film': 11,
    'Music': 12,
    'Musicals and Theatres': 13,
    'Television': 14,
    'Video Games': 15,
    'Board Games': 16,
    'Science and Nature': 17,
    'Computers': 18,
    'Mathematics': 19,
    'Mythology': 20,
    'Sports': 21,
    'Geography': 22,
    'History': 23,
    'Politics': 24,
    'Art': 25,
    'Celebrities': 26,
    'Animals': 27,
    'Vehicles': 28,
    'Comics': 29,
    'Gadgets': 30,
    'Japanese Anime and Manga': 31,
    'Cartoon and Animations': 32,
  };

  int responseCode;
  List<Results> results;
  List<AnswerWidget> ansCards;
  String link;
  int nQuestions = 3;
  int score = 0;

  int questionNumber = 0;
  Color difficultyColor = Colors.greenAccent;
  int pointsForCorrectAnswer = 50;

  bool doneLoadingData = false;
  User user;

  int correctAnswers = 0;

  var unescape = new HtmlUnescape();

  int maxScore = 0;

  @override
  void initState() {
    super.initState();

    link = "https://opentdb.com/api.php?amount=$nQuestions&category=${subjects[widget.subject]}&type=multiple";
    print(link);

    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    var res = await http.get(link);
    var decRes = jsonDecode(res.body);
    print(decRes);

    
    
    fromJson(decRes);

    user = await Database().currentUser();
    setState(() {
      doneLoadingData = true;
    });
  }

  fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    if (json['results'] != null) {
      results = List<Results>();
      json['results'].forEach((v) {
        results.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Material(
        color: const Color(0xcc2c304d),
        child: doneLoadingData ? questionList() : Container(child: Center(child: CircularProgressIndicator()))
      ),
    );
  }

  setUpQuestion(){
    if(results[questionNumber].difficulty == "hard"){
      difficultyColor = Colors.redAccent;
      pointsForCorrectAnswer = 200;
    }else if(results[questionNumber].difficulty == "medium"){
      difficultyColor = Colors.orangeAccent;
      pointsForCorrectAnswer = 100;
    }

  }



  Widget questionList() {
    String title = widget.subject;
    title = title.replaceAll("and", "&");

    setUpQuestion();

    return Container(
      margin: EdgeInsets.only(top: 40.0, left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
                      child: Text(title,
              style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w300)),
          ),

          new Container(
            margin: EdgeInsets.only(bottom: 5.0, top: 25.0),
            alignment: Alignment.centerRight,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text("Question ${questionNumber + 1} of ${results.length}",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w300)),
                new Text("Score: $score",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w300))
              ],
            ),
          ),
          Card(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top:5.0),
                alignment: Alignment.center,
                child: Text(results[questionNumber].difficulty,
                    style: TextStyle(
                        color: difficultyColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0)),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    top: 65.0, bottom: 75.0, left: 15.0, right: 15.0),
                child: Text(unescape.convert(results[questionNumber].question),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xcc2c304d))),
              ),
            ],
          )),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 5.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("+$pointsForCorrectAnswer", style: TextStyle(color: Colors.greenAccent, fontSize: 15.0)),
                Text(" points for the correct answer",
                    style: TextStyle(color: Colors.white))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top:30.0),
            child: Column(
              children: results[questionNumber].allAnswers.map((m) {
                return AnswerWidget(results[questionNumber], m,answer);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  answer(bool correctAnswer){
    maxScore = maxScore + pointsForCorrectAnswer;

    if(correctAnswer){
      print("Correct!");
      correctAnswers++;
      answeredCorrectly();
    }else {
      print("Wrong");
      nextQuestion();
    }
  }

  answeredCorrectly(){
    setState(() {
      score = score+pointsForCorrectAnswer; 
      Database().addPoints(user, pointsForCorrectAnswer);
      nextQuestion();  
    }); 
  }

  nextQuestion(){
    if(questionNumber == results.length - 1){
      print("quiz is over!");
      print("You got $correctAnswers correct out of ${results.length}");


      Application.router.navigateTo(context, "/score?subject=${widget.subject}&score=$score&totalScore=$maxScore", clearStack: true);
    }else{
      setState(() {
        questionNumber++;
      });
    }
  }


  Padding errorData(AsyncSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Error: ${snapshot.error}',
          ),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            child: Text("Try Again"),
            onPressed: () {
              fetchQuestions();
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  Future<bool> _onWillPop() {
    Application.router.navigateTo(context, "/home?subject=quiz", clearStack: true);
  }

  String styleText(String title) {
    String upperCasetitle = title.toUpperCase();
    String result = "";

    for (int i = 0; i < upperCasetitle.length; i++) {
      result = result + upperCasetitle[i] + " ";
    }
    return result;
  }
}

class AnswerWidget extends StatefulWidget {

  final String m;
  final void Function(bool) answer;
  final Results result;


  AnswerWidget(this.result, this.m, this.answer);


  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  Color answerColor = Colors.white;
  bool correctAnswer = false;
  var unescape = new HtmlUnescape();

  answer(){
    setState(() {
      
      
      if (widget.result.correctAnswer == widget.m) {
        //answerColor = Colors.greenAccent;
        correctAnswer = true;
      }else {
        //answerColor = Colors.redAccent;
      }
      
      
      widget.answer(correctAnswer);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: answerColor,
      margin: EdgeInsets.only(bottom: 20.0),
      child: ListTile(
        enabled: true,
        onTap: () => answer(),
        title: Text(
          unescape.convert(widget.m),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xcc2c304d),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class Results {
  String category;
  String type;
  String difficulty;
  String question;
  String correctAnswer;
  List<String> allAnswers;

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
    allAnswers = json['incorrect_answers'].cast<String>();
    allAnswers.add(correctAnswer);
    allAnswers.shuffle();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['type'] = this.type;
    data['difficulty'] = this.difficulty;
    data['question'] = this.question;
    data['correct_answer'] = this.correctAnswer;
    data['incorrect_answers'] = this.allAnswers;
    return data;
  }
}


