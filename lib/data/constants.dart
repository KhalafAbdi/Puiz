import 'package:flutter/material.dart';

// ------------------------------------------- Variables used in more than one file ------------------------------------------- 

final String appTitle = 'Puiz';
final String font = 'Roboto';
final Color themeBlue = const Color(0xFF2c304d);
final Color themeRed = const Color(0xFFca4451);

final String gameID = 'gameID';
final String owner = 'owner';

//Database
final String usersCollection = 'Users';
final String categoriesCollection = 'Categories';
final String gamesCollection = 'Games';
final String messagesCollection = 'Messages';
final String questionsCollection = 'questions';
final String chatCollections = 'messages';


final String newestCategoryCollection = 'Newest Category';

//SharedPreferences
final String sharedUserId = userID;
final String sharedUserMail = userMail;
final String sharedUserDisplayName = userDisplayName;
final String sharedIsLoggedIn = 'isLoggedin';

//User
final String userID = 'id';
final String userDisplayName = 'displayName';
final String userMail = 'email';
final String userLevel = 'level';
final String userPoints = 'points';
final String userCoins = 'coins';
final String userGold = 'gold';
final String userCompletedRewards = 'completedRewards';
final String userEasyRecord = 'easyRecord';
final String userMediumRecord = 'mediumRecord';
final String userHardRecord = 'hardRecord';
final String userRandomRecord = 'randomRecord';
final String userImgPath = 'imgPath';

//Game
final String gameCategory = 'category';
final String gameDifficulty = 'difficulty';
final String gameCreatorID = 'creatorID';
final String gameCreatorName = 'creatorName';
const String gameState = 'state';
final String gamePassword = 'password';
final String gameJoinerID = 'joinerID';
final String gameJoinerName = 'joinerName';

final String gameCurrentRound = 'currentquestion';
final String gameCreatorScore = 'creatorscore';
final String gameJoinerScore = 'joinerscore';

final String gameOwnerAnswer = 'ownerAnswer';
final String gameJoinerAnswer = 'joinerAnswer';
final String gameOwnerAnswerTime = 'ownerAnswertime';
final String gameJoinerAnswerTime = 'joinerAnswertime';

//Game States
final String gameStateOpen = 'open';
final String gameStateClosed = 'closed';
final String gameStateStarted = 'started';

//Difficulties
const String difficultyEasy = 'easy';
const String difficultyMedium = 'medium';
const String difficultyHard = 'hard';
const String difficultyRandom = 'random';

final String deathMatchTitle = 'D E A T H M A T C H';

// Chat message
final String messageContent = 'content';
final String messageSender = 'sender';
final String messagSenderID = 'senderID';
final String messageAvatar = 'avatar';

// API Response
final String responseCode = 'response_code';
final String responseResult = 'results';
final String responseQuestion = 'question';
final String responseQuestionIncorrectAnswers = 'incorrectAnswers';
final String responseQuestionCorrectAnswer = 'correctAnswer';
final String responseQuestionCategory= 'category';
final String responseQuestionDifficulty = 'difficulty';
final String responseQuestionType= 'type';

//Pages
final String homePageTitle = 'Home';
final String multiPlayerPageTitle = 'Multiplayer';
final String deathmatchPageTitle = 'DeathMatch';
final String quizPageTitle = 'Quiz';
final String settingsPageTitle = 'Settings';

const subjects = {
  'Any Category': null, //https://opentdb.com/api.php?amount=1
  'General Knowledge': 9, //https://opentdb.com/api.php?amount=1&category=9
  'Books': 10,
  'Film': 11,
  'Music': 12,
  'Musicals and Theatres': 13,
  'Television': 14,
  'Video Games': 15,
  'Board Games': 16,
  'Science and Nature': 17,
  'Computers': 18,
  'Mathematics': 19,
  'Mythology': 20,
  'Sports': 21,
  'Geography': 22,
  'History': 23,
  'Politics': 24,
  'Art': 25,
  'Celebrities': 26,
  'Animals': 27,
  'Vehicles': 28,
  'Comics': 29,
  'Gadgets': 30,
  'Japanese Anime and Manga': 31,
  'Cartoon and Animations': 32,
  };