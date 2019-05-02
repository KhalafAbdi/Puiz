import 'package:flutter/material.dart';

final String appTitle = 'Puiz';
final Color themeBlue = const Color(0xFF2c304d);
final Color themeRed = const Color(0xFFca4451);

final String subject = 'subject';
final String difficulty = 'difficulty';
final String score = 'score';
final String totalScore = 'totalScore';

final String gameID = 'gameID';
final String owner = 'owner';

//Database
final String usersCollection = 'Users';
final String categoriesCollection = 'Categories';
final String gamesCollection = 'Categories';

final String newestCategoryCollection = 'Newest Category';

//SharedPreferences
final String sharedUserId = 'id';
final String sharedUserMail = 'email';
final String sharedUserDisplayName = 'displayName';
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
final String gameState = 'state';
final String gamePassword = 'password';

//Game States
final String gameStateOpen = 'open';
final String gameStateClosed = 'closed';

//Difficulties
const String difficultyEasy = 'easy';
const String difficultyMedium = 'medium';
const String difficultyHard = 'hard';
const String difficultyRandom = 'random';

//Death-Match
final String deathMatchTitle = 'D E A T H M A T C H';
final String deathMatch = '';

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