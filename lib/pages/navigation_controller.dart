import 'package:flutter/material.dart';

import 'package:pro/pages/settings_page.dart';
import 'package:pro/pages/home_page.dart';
import 'package:pro/pages/quiz_tab/quiz_page.dart';
import 'package:pro/pages/deathmatch_tab/deathmatch_page.dart';
import 'package:pro/pages/multiplayer_tab/multiplayer_page.dart';

import 'package:pro/data/constants.dart' as constants;


class NavigationController extends StatefulWidget {
  final subject;

  NavigationController([this.subject]);
  
  @override
  _NavigationControllerState createState() => _NavigationControllerState();

  updateCurrentTab(int index, String title){
    _NavigationControllerState().updateCurrentTab(index,title);
  }
}

class _NavigationControllerState extends State<NavigationController> {
  int currentTab = 0;

  HomePage homePage;
  MultiplayerPage multiplayerPage;
  DeathMatchPage deathMatchPage;
  QuizPage quizzesPage;
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
    quizzesPage = QuizPage(3);
    settingsPage = SettingsPage(4);
    
    pageTitles = [constants.homePageTitle, constants.multiPlayerPageTitle, constants.deathmatchPageTitle, constants.quizPageTitle, constants.settingsPageTitle];
    pages = [homePage,multiplayerPage, deathMatchPage, quizzesPage, settingsPage];

    if(widget.subject == null){
      currentPage = homePage;
      currentTitle = constants.homePageTitle;
    }else if(widget.subject.toString().contains("quiz")){
      quizzesPage = QuizPage(3, widget.subject);
        currentTab = 3;
        currentPage = quizzesPage;
        
    }else if(widget.subject.toString().contains(constants.deathmatchPageTitle)){
      currentTab = 2;
      currentPage = deathMatchPage;
    }

    currentTitle = widget.subject; 

    super.initState();   
  }




  updateCurrentTab(int index, String title){

    if(title == null){
      setState(() {
        currentTab = index;
        currentPage = pages[index];
        currentTitle = pageTitles[index];
      });
    }else {
      setState(() {
        quizzesPage = QuizPage(3, title);
        currentTab = 3;
        currentPage = quizzesPage;
        currentTitle = title;     
      });
    }


    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: const Color(0xFFca4451),

        type: BottomNavigationBarType.fixed,
        currentIndex: currentTab,
        onTap: (int index) => updateCurrentTab(index, null),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text(constants.homePageTitle)),
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text(constants.multiPlayerPageTitle)),
          BottomNavigationBarItem(icon: Icon(Icons.face), title: Text(constants.deathmatchPageTitle)),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), title: Text(constants.quizPageTitle)),
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text(constants.settingsPageTitle))
        ],
      ),
    );
  }
}
