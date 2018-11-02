import 'package:flutter/material.dart';
import 'package:pro/pages/entry/login_page.dart';
import 'package:pro/pages/entry/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pro/pages/navigation_controller.dart';
import 'package:pro/pages/onBoarding/onBoardingController.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => NavigationController(),
        '/onBoarding': (context) => OnBoadingControllerPage()
      },
    );
  }
}

class LandingPage extends StatefulWidget {
  final String title = "Base App";

  @override
  _LandingPageState createState() => new _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {

    checkIfUserIsLoggedIn();

    return Material(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFca4451), const Color(0xFF2c304d)],
                begin: FractionalOffset(0.5, 0.42),
                end: FractionalOffset(1.0, 0.5),
                stops: [0.5, 0.5],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                greeting(),
                buttons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  greeting() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Icon(
                Icons.whatshot,
                  color: Colors.white,
                  size: 150.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  buttons(){
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Container(
            
            alignment:Alignment.centerLeft,
            color: const Color(0xFF2c304d),
            child: MaterialButton(
                child: Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Roboto', fontSize: 25.0, fontWeight: FontWeight.w300),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                }),
          ),
          Container(
            
            alignment:Alignment.centerRight,
            margin: EdgeInsets.only(bottom: 10.0),
            color: const Color(0xFFca4451),
            child: MaterialButton(
                child: Text(
                  "Register",
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Roboto', fontSize: 25.0, fontWeight: FontWeight.w300),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                }),
          )
        ],
      ),
    );
  }


  void checkIfUserIsLoggedIn() async{
    FirebaseUser _auth = await FirebaseAuth.instance.currentUser();

    if(_auth != null){
      print("user is logged in ${_auth.email}");
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    }else{
      print("user is not logged in");
    }
  }
}
