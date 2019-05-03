import 'package:pro/data/constants.dart' as constants;

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
    category = json[constants.responseQuestionCategory];
    type = json[constants.responseQuestionType];
    difficulty = json[constants.responseQuestionDifficulty];
    question = json[constants.responseQuestion];
    correctAnswer = json[constants.responseQuestionCorrectAnswer];
    allAnswers = json[constants.responseQuestionIncorrectAnswers].cast<String>();
    allAnswers.add(correctAnswer);
    allAnswers.shuffle();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[constants.responseQuestionCategory] = this.category;
    data[constants.responseQuestionType] = this.type;
    data[constants.responseQuestionDifficulty] = this.difficulty;
    data[constants.responseQuestion] = this.question;
    data[constants.responseQuestionCorrectAnswer] = this.correctAnswer;
    data[constants.responseQuestionIncorrectAnswers] = this.allAnswers;
    return data;
  }
}