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
  Widget middleSection = new Expanded(
    child: new Container (
      padding: new EdgeInsets.all(8.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: FlutterLogo( 
              style: FlutterLogoStyle.horizontal,
              textColor: Colors.white,
              size: 300.0,
            ),
          )
        ],
      ),
    ),
  );

  Widget bottomBanner(BuildContext context){
    return new Container (
    margin: EdgeInsets.all(8.0),
    padding: new EdgeInsets.all(8.0),
    height: 194.0,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: new BorderRadius.circular(5.0)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 15.0, left: 15.0, right:15.0),
          child: Center(
            child: Text("Welcome To Puiz", 
              style: TextStyle(fontSize: 25.0, color: Colors.black, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
            )
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 25.0),
          child: Center(
            child: Text("Login or Register to get started", 
              style: TextStyle(fontSize: 10.0, fontStyle: FontStyle.italic)
            )
          )
        ),
        Container(
          child: FlatButton(
            child: Text("Login", style: TextStyle(fontSize:18.0)), 
            onPressed: () => Navigator.pushNamed(context, '/login')
          ),
        ),
        new SizedBox(
          height: 1.0,
          child: new Center(
            child: new Container(
              margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
              height: 1.0,
              decoration: BoxDecoration(
          color: Colors.black12,
        ),
            ),
          ),
        ),
        Container(
          child: FlatButton(
            child:Text("Register", style: TextStyle(fontSize:18.0)), 
            onPressed: () => Navigator.pushNamed(context, '/register'),
          ),
        ),
      ],
    )
  );
  }

  @override
  Widget build(BuildContext context) {
    checkIfUserIsLoggedIn();
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFfe7f3b), const Color(0xFFfe2851)],
            begin: FractionalOffset(0.0, 1.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
        ),
        child: Column(
          children: <Widget>[
            middleSection,
            bottomBanner(context)
          ],
        ),
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
