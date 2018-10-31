import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("H O M E"),
              backgroundColor: const Color(0xFF2c304d),
            ),
            body: buildBody(context)));
  }

  buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, const Color(0xFFca4451)],
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(0.3, 0.15),
              stops: [1.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[welcomeCard(), scoreCards(context)],
          ),
        )
      ],
    );
  }

  Widget progressToNextLevel(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double test = width * 0.65;

    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Center(
            child:Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text("Score to Next level",
                style: TextStyle(fontSize: 18.0, color: const Color(0xFF2c304d), fontWeight: FontWeight.w300)
              ),
            )
          ),
          Container(
            width: width,
            child: Stack(
              children: <Widget>[
                Container(
                  width: width,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFeaeaea),
                    
                  ),
                ),
                Container(
                  width: test,
                  height: 20.0,
                  color: const Color(0xFFca4451),
                ),
                Container(
                  height: 20.0,
                  alignment: Alignment.center, 
                  child: Text("600/1000", 
                    style: TextStyle(
                      color:Colors.white, 
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300
                    )
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget scoreCard(String title, int score, bool divider) {
    return Expanded(
      child: Container(
        decoration: divider ? BoxDecoration(border: BorderDirectional(end: BorderSide())) : null,
        child: Column(
          children: <Widget>[
            Container(
              child: Center(child: Text(title, style: TextStyle(color: const Color(0xFF2c304d), fontWeight: FontWeight.bold),)),
            ),
            Container(
              child: Center(
                child: Text(
                  score.toString(),
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget scoreCards(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15.0),
        child: Column(
          children:<Widget>[
            Container(
              padding:EdgeInsets.all(7.0),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  scoreCard("Points", 600, true),
                  scoreCard("Level", 5, true),
                  scoreCard("Coins", 1800, true),
                  scoreCard("Gold", 500, false)
                ],
              ),
            ),
            progressToNextLevel(context)
          ],
        ),
    );
  }

  

  Widget welcomeCard() {
    return Card(
      margin: EdgeInsets.only(top:15.0, left: 15.0, right: 15.0),
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(vertical: 25.0),
              child: Text(
                "Welcome Back, User",
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Roboto', fontSize: 20.0),
              )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Here is how many questions you answered correctly this week! Answer 15 more questions for next reward!",
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Roboto', fontSize: 15.0),
                    textAlign: TextAlign.center
              )),
          Container(
              margin: EdgeInsets.only(
                  top: 25.0, bottom: 25.0, left: 10.0, right: 10.0),
              child: FlutterLogo()),
          themeButton("Start new Quiz", 20.0)
        ],
      ),
    );
  }

  Widget themeButton(title, size) {
    return Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
      color: const Color(0xFF2c304d),
      child: MaterialButton(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontFamily: 'Roboto', fontSize: size),
          ),
          onPressed: () {
            print("Start new game clicked");
          }),
    );
  }
}
