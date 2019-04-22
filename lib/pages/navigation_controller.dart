import 'package:flutter/material.dart';
import 'package:pro/pages/settings.dart';
import 'package:pro/pages/home.dart';
import 'package:pro/pages/quiz/quizzes.dart';
import 'package:pro/pages/deathmatch/deathmatch.dart';
import 'package:pro/pages/multiplayer/multiplayer.dart';

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

    if(widget.subject == null){
      currentPage = homePage;
      currentTitle = "Home";
    }else if(widget.subject.toString().contains("quiz")){
      quizzesPage = QuizzesPage(3, widget.subject);
        currentTab = 3;
        currentPage = quizzesPage;
        
    }else if(widget.subject.toString().contains("deathmatch")){
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
        quizzesPage = QuizzesPage(3, title);
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
