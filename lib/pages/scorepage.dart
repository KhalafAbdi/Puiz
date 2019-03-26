import 'package:flutter/material.dart';
import 'package:pro/config/application.dart';

class ScorePage extends StatelessWidget {
  final subject;
  final score;
  final totalScore;

  ScorePage({@required this.subject, @required this.score, @required this.totalScore});
  String path;
  Widget widget;
  String comment = "Good";
  List<String> data;

  @override
  Widget build(BuildContext context) {
     
    print("info for $subject: Score:$score, Total score:$totalScore");

    var scoreInt = int.parse(score);
    assert(scoreInt is int);

    var totalScoreInt = int.parse(totalScore);
    assert(totalScoreInt is int);

    double res = scoreInt/totalScoreInt;

    if(res >= 0.6 && res < 0.7){
      comment = "NICE";
    }else if(res > 0.7 && res < 0.8){
      comment = "awesome";
    }else if(res > 0.8 && res < 0.9){
      comment = "phenomenal";
    }else if(res > 0.9 && res < 0.95){
      comment = "marvelous";
    }else if(res > 0.95 && res == 1){
      comment = "unbelievable";
    }

    if (subject.toString().contains("DeathMatch")){
      
      data = subject.toString().split(":");
      path = "/dmquiz?difficulty=${data[1]}";

      widget = deathMatchWidget(context);

    }else {
      path = "/quiz?subject=$subject";
      widget = quizWidget(context);
    }

    return widget;
  }



Widget deathMatchWidget(BuildContext context){
  var message;
  var currentRecord = int.parse(data[2]);
  var newScore = int.parse(data[3]);
  Widget scoreWidget;

  if(newScore > currentRecord){
    message = "New Record!";
    scoreWidget = winningWidget(newScore);
  }else if(newScore == currentRecord){
    message = "Tied your Record!";
    scoreWidget = loseWidget(newScore, currentRecord);
  }else {
    message = "Maybe next time";
    scoreWidget = loseWidget(newScore, currentRecord);
  }

  return Material(
      child: Container(
        color: const Color(0xFFca4451),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message, 
              style: textStyle(55.0, const Color(0xFF2c304d), FontWeight.w900), 
              textAlign: TextAlign.center,),
            new Container(
              margin: EdgeInsets.only(bottom: 5.0, top: 25.0),
              alignment: Alignment.center,
              child: scoreWidget
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Text("YOU GOT", style: textStyle(25.0, const Color(0xFF2c304d), FontWeight.w300))),
            Text(score, 
              style: textStyle(90.0, Colors.white, FontWeight.w900), 
              textAlign: TextAlign.center,),
            Text("Points", style: textStyle(25.0, const Color(0xFF2c304d), FontWeight.w300)),
            Container(
              margin: EdgeInsets.only(top:45.0),
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
                    onTap: () => Application.router.navigateTo(context, path, clearStack: true),
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

Widget loseWidget(var newScore, var currentRecord){
  return new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      new Text("Streak: ",
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300)),

                      new Text("$newScore",
                      style: TextStyle(
                          fontSize: 75.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w300)),
                    ],
                  ),

                  Column(
                    children: <Widget>[
                      new Text("Record: ",
                      style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w300)),

                      new Text("$currentRecord",
                      style: TextStyle(
                          fontSize: 75.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w300)),
                    ],
                  )
 
                ],
              );
}

Widget winningWidget(var newScore){
 return Column(
                    children: <Widget>[
                      new Text("${data[1].toUpperCase()} ",
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300)),

                      new Text("$newScore",
                      style: TextStyle(
                          fontSize: 90.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w300)),
                    ],
                  );

}



Widget quizWidget(BuildContext context){
  return Material(
      child: Container(
        color: const Color(0xFF2c304d),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("${comment.toUpperCase()} GAME", 
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
                    onTap: () => Application.router.navigateTo(context, path, clearStack: true),
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

  TextStyle textStyle(double size, Color color, [FontWeight f]){
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: (f == null) ? FontWeight.normal : f);
  }
}