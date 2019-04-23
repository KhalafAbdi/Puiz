import 'package:flutter/material.dart';

class Question{
  String question;
  String correctAnswer;
  List<String> incorrectAnswers;

  String ownerAnswer;
  DateTime ownerAnswertime;
  String joinerAnswer;
  DateTime joinerAnswertime;

  Question({
    this.question,
    this.correctAnswer,
    this.incorrectAnswers
  });

  Map<String,dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['question'] = question;
    map['correctAnswer'] = correctAnswer;
    map['incorrectAnswers'] = incorrectAnswers;

    //map['sent'] = DateTime.now().millisecondsSinceEpoch;
    return map;
  }
}