import 'package:flutter/material.dart';
import 'package:pro/pages/settings.dart';
import 'package:pro/pages/home.dart';

class NavigationController extends StatefulWidget {
  @override
  _NavigationControllerState createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  int currentTab = 0;

  SettingsPage settingsPage;
  HomePage homePage;
  List<Widget> pages;
  List<String> pageTitles;
  Widget currentPage;
  String currentTitle;

  @override
  initState(){
    homePage = HomePage();
    settingsPage = SettingsPage();
    


    pageTitles = ["Home", "Settings"];
    pages = [homePage, settingsPage];
    currentPage = homePage;
    currentTitle = "Home";
    super.initState();   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(currentTitle),
        automaticallyImplyLeading: false,
      ),
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
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
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("Settings"))
        ],
      ),
    );
  }
}

