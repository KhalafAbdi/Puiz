import 'package:flutter/material.dart';
import 'package:pro/pages/settings.dart';
import 'package:pro/pages/home.dart';
import 'package:pro/pages/quizzes.dart';
import 'package:pro/pages/deathmatch.dart';
import 'package:pro/pages/multiplayer.dart';

class NavigationController extends StatefulWidget {
  
  @override
  _NavigationControllerState createState() => _NavigationControllerState();

  updateCurrentTab(int index){
    _NavigationControllerState().updateCurrentTab(index);
  }
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
    homePage = HomePage(0, updateCurrentTab);
    multiplayerPage = MultiplayerPage(1);
    deathMatchPage = DeathMatchPage(2);
    quizzesPage = QuizzesPage(3);
    settingsPage = SettingsPage(4);
    
    pageTitles = ["Home", "Multiplayer", "DeathMatch", "Quiz", "Settings"];
    pages = [homePage,multiplayerPage, deathMatchPage, quizzesPage, settingsPage];
    currentPage = homePage;
    currentTitle = "Home";
    super.initState();   
  }




  updateCurrentTab(int index){
    setState(() {
      currentTab = index;
      currentPage = pages[index];
      currentTitle = pageTitles[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentTab,
        onTap: (int index) => updateCurrentTab(index),
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
