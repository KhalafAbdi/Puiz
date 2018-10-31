import 'package:flutter/material.dart';
import 'package:pro/pages/quiz.dart';
import 'package:pro/pages/questions.dart';
import 'package:pro/widgets/answer_button.dart';
import 'package:pro/widgets/question_text.dart';
import 'package:pro/widgets/correct_wrong_overlay.dart';

import './score_page.dart';

class QuizPage extends StatefulWidget {
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {

  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question("Elon musk is human", false),
    new Question("Pizza is healthy", false),
    new Question("Flutter is awesome", true),
  ]);
  
  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayShouldBeVisable = false;

  @override
  void initState(){
    super.initState();

    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
  }

  void handleAnswer(bool answer){
    isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect);
    this.setState(() {
      overlayShouldBeVisable = true;
    });
  }

  @override
  Widget build(BuildContext context){
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column( //this is our main page
          children: <Widget>[
            new AnswerButton(true, () => handleAnswer(true)),
            new QuestionsText(questionNumber, questionText),
            new AnswerButton(false, () => handleAnswer(false))
          ],
        ),
        overlayShouldBeVisable == true ? new CorrectWrongOverlay(
          isCorrect, 
          () {
            if (quiz.Lenght == questionNumber){
              Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score, quiz.Lenght)), (Route route) => route == null);
              return;
            }

            currentQuestion = quiz.nextQuestion;
            this.setState(() {
              overlayShouldBeVisable = false;
              questionText = currentQuestion.question;
              questionNumber = quiz.questionNumber;
            });
          }
        ) : new Container()
      ],
    );
  }
}