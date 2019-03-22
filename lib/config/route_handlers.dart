import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:pro/pages/landingPage.dart';
import 'package:pro/pages/entry/login_page.dart';
import 'package:pro/pages/entry/register_page.dart';
import 'package:pro/pages/navigation_controller.dart';
import 'package:pro/pages/onBoarding/onBoardingController.dart';
import 'package:pro/pages/quizpage.dart';
import 'package:pro/pages/scorepage.dart';
import 'package:pro/pages/deathmatchquizpage.dart';

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
  return QuizPage(subject : subject);
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
