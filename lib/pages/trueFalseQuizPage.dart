import 'package:flutter/material.dart';
import './quiz_page.dart';


class TrueFalseQuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Material(
      color: Colors.greenAccent,
      child: new InkWell(
        onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new QuizPage())),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: new Text("Lets Quizz", style: new TextStyle(color: Colors.white, fontSize: 50.0, fontWeight:FontWeight.bold),)),
            Center(child: new Text("Tap to start!", style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight:FontWeight.bold),))
          ],
        ),
      ),
    )
    );
  }
}



