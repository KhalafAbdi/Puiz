import 'package:flutter/material.dart';
import 'package:pro/pages/multiplayer_tab/model/question.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameQuiz extends StatefulWidget {
  final gameID;

  GameQuiz(this.gameID);

  @override
  _GameQuizState createState() => _GameQuizState();
}

class _GameQuizState extends State<GameQuiz> {
  bool isLoading = true;

  List<Question> questions = [];
  
  @override
  void initState() {
    super.initState();

    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    
    QuerySnapshot v = await Firestore.instance.collection('Messages').document("-Ld9Nx41L3-Dhxpd_ze3").collection("questions").getDocuments();
    
    for (DocumentSnapshot item in v.documents) {
      
      List<String> list = [];
      list.addAll(item.data['incorrectAnswers'].cast<String>());

      Question question = new Question(
        question: item.data['question'],
        correctAnswer: item.data['question'],
        incorrectAnswers: list
      );

      questions.add(question);
      
      

    }

    setState(() {
      isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Material(
        color: const Color(0xcc2c304d),
        child: !isLoading ? questionList() : Container(child: Center(child: CircularProgressIndicator()))
    );
  }

  Widget questionList(){
    return Container(
      child: Text("Its motherfucking workings")
    );
  }
}