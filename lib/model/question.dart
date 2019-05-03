import 'package:pro/data/constants.dart' as constants;

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
    map[constants.responseQuestion] = question;
    map[constants.responseQuestionCorrectAnswer] = correctAnswer;
    map[constants.responseQuestionIncorrectAnswers] = incorrectAnswers;

    map[constants.gameOwnerAnswer] = ownerAnswer;
    map[constants.gameOwnerAnswerTime] = ownerAnswertime;
    map[constants.gameJoinerAnswer] = joinerAnswer;
    map[constants.gameJoinerAnswerTime] = joinerAnswertime;
      
    return map;
  }
}