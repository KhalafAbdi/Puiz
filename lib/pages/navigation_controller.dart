import 'package:flutter/material.dart';
import 'package:pro/pages/settings.dart';
import 'package:pro/pages/home.dart';
import 'package:pro/pages/quizzes.dart';
import 'package:pro/pages/deathmatch.dart';
import 'package:pro/pages/multiplayer.dart';

class NavigationController extends StatefulWidget {
  @override
  _NavigationControllerState createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  int currentTab = 0;

  HomePage homePage;
  MultiplayerPage multiplayerPage;
  DeathMatchPage deathMatchPage;
  QuizzesPage quizzesPage;
  SettingsPage settingsPage;

  List<Widget> pages;
  List<String> pageTitles;

  Widget currentPage;
  String currentTitle;

  @override
  initState(){
    homePage = HomePage();
    settingsPage = SettingsPage();
    quizzesPage = QuizzesPage();
    deathMatchPage = DeathMatchPage();
    multiplayerPage = MultiplayerPage();
    
    pageTitles = ["Home", "Multiplayer", "DeathMatch", "Quiz", "Settings"];
    pages = [homePage,multiplayerPage, deathMatchPage, quizzesPage, settingsPage];
    currentPage = homePage;
    currentTitle = "Home";
    super.initState();   
  }

  setCurrentTitle(String test){
    setState(() {
       currentTitle = test;   
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
            currentTitle = pageTitles[index];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text("Multiplayer")),
          BottomNavigationBarItem(icon: Icon(Icons.face), title: Text("DeathMatch")),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), title: Text("Quiz")),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("Settings"))
        ],
      ),
    );
  }
}
