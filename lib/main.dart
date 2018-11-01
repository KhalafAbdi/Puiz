import 'package:flutter/material.dart';
import 'package:pro/pages/entry/login_page.dart';
import 'package:pro/pages/entry/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pro/pages/navigation_controller.dart';

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
        '/home': (context) => NavigationController()
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          button("Login", 25.0, const Color(0xFF2c304d),"/login"),
          button("Register", 25.0, const Color(0xFFca4451), "/register")
        ],
      ),
    );
  }

  Widget button(title, size, color, goto) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      color: color,
      child: MaterialButton(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontFamily: 'Roboto', fontSize: size, fontWeight: FontWeight.w300),
          ),
          onPressed: () {
            Navigator.pushNamed(context, goto);
          }),
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
