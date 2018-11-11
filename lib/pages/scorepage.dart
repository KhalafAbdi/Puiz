import 'package:flutter/material.dart';
import 'package:pro/config/application.dart';

class ScorePage extends StatelessWidget {
  final subject;
  final score;
  final totalScore;

  ScorePage({@required this.subject, @required this.score, @required this.totalScore});

  @override
  Widget build(BuildContext context) {
    String t = "Good";

    print("info for $subject: Score:$score, Total score:$totalScore");

    var scoreInt = int.parse(score);
    assert(scoreInt is int);

    var totalScoreInt = int.parse(totalScore);
    assert(totalScoreInt is int);

    double res = scoreInt/totalScoreInt;

    if(res >= 0.6 && res < 0.7){
      t = "NICE";
    }else if(res > 0.7 && res < 0.8){
      t = "awesome";
    }else if(res > 0.8 && res < 0.9){
      t = "phenomenal";
    }else if(res > 0.9 && res < 0.95){
      t = "marvelous";
    }else if(res > 0.95 && res == 1){
      t = "unbelievable";
    }

    return Material(
      child: Container(
        color: const Color(0xFF1c2754),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("${t.toUpperCase()} GAME", 
              style: textStyle(55.0, const Color(0xFFca4451), FontWeight.w900), 
              textAlign: TextAlign.center,),
            Container(
              margin: EdgeInsets.only(top: 55.0, bottom: 10.0),
              child: Text("YOU SCORED", style: textStyle(25.0, Colors.white, FontWeight.w300))),
            Text(score, 
              style: textStyle(90.0, const Color(0xFFca4451), FontWeight.w900), 
              textAlign: TextAlign.center,),
            Container(
              margin: EdgeInsets.only(top:25.0),
                          child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: () => Application.router.navigateTo(context, "/home"),
                    child: Container(
                      color: Colors.white,
                      child: Text("Back", style: textStyle(25.0, const Color(0xFF1c2754)),),
                      padding: EdgeInsets.only(top:10.0, bottom: 10.0, left: 20.0, right: 20.0),
                    )),
                  InkWell(
                    onTap: () => Application.router.navigateTo(context, "/quiz?subject=$subject", clearStack: true),
                    child: Container(
                      color: Colors.white,
                      child: Text("Play again", style: textStyle(25.0, const Color(0xFF1c2754)),),
                      padding: EdgeInsets.only(top:10.0, bottom: 10.0, left: 20.0, right: 20.0),
                    )),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

//onPressed: () => Application.router.navigateTo(context, "/home?subject=quiz"),

  TextStyle textStyle(double size, Color color, [FontWeight f]){
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: (f == null) ? FontWeight.normal : f);
  }
}