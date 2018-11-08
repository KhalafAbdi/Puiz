import 'package:flutter/material.dart';
import 'package:pro/config/app_component.dart';

import 'package:pro/pages/entry/login_page.dart';
import 'package:pro/pages/entry/register_page.dart';
import 'package:pro/pages/navigation_controller.dart';
import 'package:pro/pages/onBoarding/onBoardingController.dart';
import 'package:pro/pages/landingPage.dart';



void main() => runApp(new AppComponent());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        accentColor: const Color(0xFFca4451)
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => NavigationController(),
        '/onBoarding': (context) => OnBoadingControllerPage(),
      },
    );
  }
}

