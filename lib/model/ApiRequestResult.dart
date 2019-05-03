import 'package:pro/data/constants.dart' as constants;

class Results {
  String category;
  String type;
  String difficulty;
  String question;
  String correctAnswer;
  List<String> allAnswers;
  List<String> incorrectAnswers;

  Results({
    this.category,
    this.type,
    this.difficulty,
    this.question,
    this.correctAnswer,
  });

  Results.fromJson(Map<String, dynamic> json, {bool useAllAnswers: true}) {
    category = json[constants.responseQuestionCategory];
    type = json[constants.responseQuestionType];
    difficulty = json[constants.responseQuestionDifficulty];
    question = json[constants.responseQuestion];
    correctAnswer = json[constants.responseQuestionCorrectAnswer];

    if(useAllAnswers){
      allAnswers = json[constants.responseQuestionIncorrectAnswers].cast<String>();
      allAnswers.add(correctAnswer);
      allAnswers.shuffle();
    }else {
      incorrectAnswers = json[constants.responseQuestionIncorrectAnswers].cast<String>();
    }    
  }

  Map<String, dynamic> toJson({bool useAllAnswers: true}) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[constants.responseQuestionCategory] = this.category;
    data[constants.responseQuestionType] = this.type;
    data[constants.responseQuestionDifficulty] = this.difficulty;
    data[constants.responseQuestion] = this.question;
    data[constants.responseQuestionCorrectAnswer] = this.correctAnswer;
    
    if(useAllAnswers){
      data[constants.responseQuestionIncorrectAnswers] = this.allAnswers;
    }else {
      data[constants.responseQuestionIncorrectAnswers] = this.incorrectAnswers;
    }

    return data;
  }
}