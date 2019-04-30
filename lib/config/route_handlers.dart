import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:pro/pages/landing_page.dart';

import 'package:pro/pages/entry/login_page.dart';
import 'package:pro/pages/entry/register_page.dart';

import 'package:pro/pages/navigation_controller.dart';

import 'package:pro/pages/onBoarding/onboarding_controller.dart';

import 'package:pro/pages/quiz_tab/quiz_game.dart';

import 'package:pro/widgets/score_page.dart';

import 'package:pro/pages/deathmatch_tab/deathmatch_quiz.dart';

import 'package:pro/pages/multiplayer_tab/game_creation.dart';
import 'package:pro/pages/multiplayer_tab/game_lobby.dart';

import 'package:pro/pages/edit_avatar_page.dart';

var rootHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LandingPage();
});

var loginHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return LoginPage();
});

var registerHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return RegisterPage();
});

var homeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String subject = params["subject"]?.first;
  return NavigationController(subject);
});

var onBoardingHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return OnBoadingControllerPage();
});

var quizHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String subject = params["subject"]?.first;
  return QuizGame(subject : subject);
});

var dmquizHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String difficulty = params["difficulty"]?.first;
  return DeathMatchQuizPage(difficulty : difficulty);
});

var scoreHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String subject = params["subject"]?.first;
    String score = params["score"]?.first;
    String totalScore = params["totalScore"]?.first;
  return ScorePage(subject: subject, score: score, totalScore: totalScore);
});

var createNewGameHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return GameCreation();
});

var multiplayerGameHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String gameID = params["gameID"]?.first;
    String owner = params["owner"]?.first;
  return GameLobby(gameID : gameID, owner: owner);
});

var editAvatarHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return EditAvatarPage();
});

