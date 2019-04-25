import 'package:flutter/material.dart';

class Question{
  String question;
  String correctAnswer;
  List<String> incorrectAnswers;

  String ownerAnswer = "";
  DateTime ownerAnswertime;
  String joinerAnswer = "";
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

   
    map['ownerAnswer'] = ownerAnswer;
    map['joinerAnswer'] = joinerAnswer;
      
    return map;
  }

  Map<String,dynamic> toNewMap(String one, String two){
    var map = new Map<String, dynamic>();
    map['question'] = question;
    map['correctAnswer'] = correctAnswer;
    map['incorrectAnswers'] = incorrectAnswers;

    
    

    if(one != "" && one != null){
      
      map['ownerAnswertime'] = DateTime.now().millisecondsSinceEpoch;
      map['ownerAnswer'] = one;
    }else {
      map['ownerAnswer'] = "";
    }

    if(two != "" && two != null){
      map['joinerAnswer'] = two;
      map['joinerAnswertime'] = DateTime.now().millisecondsSinceEpoch;
    }else {
      map['joinerAnswer'] = "";
    }
    
    return map;
  }
}