import 'package:flutter/material.dart';
import 'package:pro/config/application.dart';

class QuizPage extends StatefulWidget {
  final subject;

  QuizPage({@required this.subject});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

@override
void initState(){
  super.initState();
  print(widget.subject);
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
        child: Material(
          child: Container(
          color: Colors.red,
          child: Text(widget.subject),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    Application.router.navigateTo(context, "/", clearStack: true);
  }
}