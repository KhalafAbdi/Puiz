import 'package:flutter/material.dart';

import 'package:pro/pages/home_page.dart';
import 'package:pro/pages/quiz_tab/quiz_page.dart';
import 'package:pro/pages/deathmatch_tab/deathmatch_page.dart';
import 'package:pro/pages/multiplayer_tab/multiplayer_page.dart';

import 'package:pro/data/constants.dart' as constants;

import 'package:pro/data/database.dart';


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
    
    pageTitles = [constants.homePageTitle, constants.multiPlayerPageTitle, constants.deathmatchPageTitle, constants.quizPageTitle, 'LogOut'];
    pages = [homePage,multiplayerPage, deathMatchPage, quizzesPage];

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

    if(index == 4){
      print("Logout");
      _signOut();
    }else{

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
          BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), title: Text('LogOut'))
        ],
      ),
    );
  }

  void _signOut() {
    Database().signOut();

    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}
