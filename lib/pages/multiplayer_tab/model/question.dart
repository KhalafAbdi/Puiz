import 'package:flutter/material.dart';

class Question{
  String question;
  String correctAnswer;
  List<String> incorrectAnswers;

  String ownerAnswer = "";
  int ownerAnswertime;
  String joinerAnswer = "";
  int joinerAnswertime;

  Question({
    this.question,
    this.correctAnswer,
    this.incorrectAnswers
  });

  Question.answer({
    this.question,
    this.correctAnswer,
    this.incorrectAnswers,
    this.ownerAnswer,
    this.ownerAnswertime,
    this.joinerAnswer,
    this.joinerAnswertime,
  });

  Map<String,dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['question'] = question;
    map['correctAnswer'] = correctAnswer;
    map['incorrectAnswers'] = incorrectAnswers;

   
    map['ownerAnswer'] = ownerAnswer;
    map['ownerAnswertime'] = ownerAnswertime;
    map['joinerAnswer'] = joinerAnswer;
    map['joinerAnswertime'] = joinerAnswertime;

    print("ownerAnswer: " + ownerAnswer);
    print("ownerAnswertime: " + ownerAnswertime.toString());
    print("joinerAnswer: " + joinerAnswer);
    print("joinerAnswertime: " + joinerAnswertime.toString());
      
    return map;
  }
}