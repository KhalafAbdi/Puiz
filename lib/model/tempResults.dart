import 'package:pro/data/constants.dart' as constants;

//TODO: Only used in game_lobby

class Results {
  String category;
  String type;
  String difficulty;
  String question;
  String correctAnswer;
  List<String> incorrectAnswers;

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
    incorrectAnswers = json[constants.responseQuestionIncorrectAnswers].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[constants.responseQuestionCategory] = this.category;
    data[constants.responseQuestionType] = this.type;
    data[constants.responseQuestionDifficulty] = this.difficulty;
    data[constants.responseQuestion] = this.question;
    data[constants.responseQuestionCorrectAnswer] = this.correctAnswer;
    data[constants.responseQuestionIncorrectAnswers] = this.incorrectAnswers;
    return data;
  }
}
