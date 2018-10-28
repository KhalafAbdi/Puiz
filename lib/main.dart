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
  

  void test() async{
    FirebaseUser _auth = await FirebaseAuth.instance.currentUser();

    if(_auth != null){
      print("user is logged in ${_auth.email}");
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    }else{
      print("user is not logged in");
    }

  }

  @override
  Widget build(BuildContext context) {
    test();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("Login"),
            onPressed: () => Navigator.pushNamed(context, '/login'),
          ),
          RaisedButton(
            child: Text("Register"),
            onPressed: () => Navigator.pushNamed(context, '/register'),
          )
        ],
      )
    );
  }
}

