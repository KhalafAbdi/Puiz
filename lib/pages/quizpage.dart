import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pro/config/application.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class QuizPage extends StatefulWidget {
  final subject;

  QuizPage({@required this.subject});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  var subjects = {
    'Any Category': null, //https://opentdb.com/api.php?amount=1
    'General Knowledge': 9, //https://opentdb.com/api.php?amount=1&category=9
    'Books' : 10,
    'Film' : 11,
    'Music' : 12,
    'Musicals & Theatres' : 13,
    'Television' : 14,
    'Video Games' : 15,
    'Board Games' : 16,
    'Science & Nature' : 17,
    'Computers' : 18,
    'Mathematics' : 19,
    'Mythology' : 20,
    'Sports' : 21,
    'Geography' : 22,
    'History' : 23,
    'Politics' : 24,
    'Art' : 25,
    'Celebrities' : 26,
    'Animals' : 27,
    'Vehicles' : 28,
    'Entertainment' : 29,
    'Gadgets' : 30,
    'Japanese Anime & Manga' : 31,
    'Cartoon & Animations' : 32,
  };

  int responseCode;
  List<Results> results;
  String link;
  int nQuestions = 5;

  int counter = 0;
  Widget w;
   
  @override
  void initState() {
    super.initState();

    link = "https://opentdb.com/api.php?amount=$nQuestions&category=${subjects[widget.subject]}&type=multiple";
    print(link);
  }

  Future<void> fetchQuestions() async {
    var res = await http.get(link);
    var decRes = jsonDecode(res.body);
    print(decRes);

    fromJson(decRes);
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
          child: RefreshIndicator(
        onRefresh: fetchQuestions,
        child: FutureBuilder(
            future: fetchQuestions(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Press button to start.');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  if (snapshot.hasError) return errorData(snapshot);
                  return questionList();
              }
              return Container();
            }),
      ),
      ),
    );
  }

  Widget questionList(){
    List l = [];
    l.addAll(results[counter].allAnswers);


    return Container(
      margin: EdgeInsets.only(top:30.0, left: 15.0, right: 15.0),
      child: Column(
        children: <Widget>[
          Text("Question $counter/$nQuestions"),
          Text(results[counter].question),
          Text(l.toString()),
          
          RaisedButton(
            onPressed: () => couterAdd,
          )
        ],
      ),
    );
  }

  couterAdd(){
    setState(() {
      counter++;
    w = questionList();    
        });
    
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
    Application.router.navigateTo(context, "/", clearStack: true);
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
