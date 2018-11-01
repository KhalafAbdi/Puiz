import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("H O M E",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300)),
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
        SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                welcomeCard(),
                scoreCards(context),
                newCategory(),
                challengeCard()
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget welcomeCard() {
    return Card(
      margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(vertical: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Welcome Back, ",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "User",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 20.0),
                  )
                ],
              )),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                  "Here is how many questions you answered correctly this week! Answer 15 more questions for next reward!",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Roboto',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center)),
          Container(
            margin: EdgeInsets.only(
              top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
            child: new IconButton(
              iconSize: 125.0,
              icon: new Image.asset('assets/avataaars.png'),
              tooltip: 'Edit Avatar',
              onPressed: () => {},
            )
          ),
          themeButton("Start new Quiz", 20.0)
        ],
      ),
    );
  }

  Widget themeButton(title, size) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
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

  Widget scoreCards(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(7.0),
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

  Widget scoreCard(String title, int score, bool divider) {
    return Expanded(
      child: Container(
        decoration: divider
            ? BoxDecoration(border: BorderDirectional(end: BorderSide()))
            : null,
        child: Column(
          children: <Widget>[
            Container(
              child: Center(
                  child: Text(
                title,
                style: TextStyle(
                    color: const Color(0xFF2c304d),
                    fontWeight: FontWeight.bold),
              )),
            ),
            Container(
              child: Center(
                  child: Text(
                score.toString(),
                style: TextStyle(
                  color: Colors.grey,
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget progressToNextLevel(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double percent = width * 0.65;

    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          Center(
              child: Container(
            margin: EdgeInsets.only(bottom: 5.0),
            child: Text("Score to Next level",
                style: TextStyle(
                    fontSize: 18.0,
                    color: const Color(0xFF2c304d),
                    fontWeight: FontWeight.w300)),
          )),
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
                  width: percent,
                  height: 20.0,
                  color: const Color(0xFFca4451),
                ),
                Container(
                    height: 20.0,
                    alignment: Alignment.center,
                    child: Text("600/1000",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w300)))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget newCategory() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0),
                  child: Text(
                    "New Quiz Category Available!",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 17.0),
                  ),
                ),
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    height: 30.0,
                    width: 20.0,
                    color: const Color(0xFF5592e1),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 7.0),
            color: const Color(0xFF5592e1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding:
                        EdgeInsets.only(top: 15.0, left: 15.0, bottom: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: BorderDirectional(
                              end: BorderSide(color: Colors.white))),
                      padding: EdgeInsets.only(right: 15.0),
                      child: Icon(
                        Icons.assistant,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    )),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10.0, left: 15.0),
                      child: Text(
                        "History",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15.0, bottom: 5.0),
                      child: Text(
                        "Past events, Historic people, Wars, etc.",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFFeaeaea),
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget challengeCard() {
    return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0),
                  child: Text(
                    "Win A DeathMatch For Next Reward",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Roboto',
                        fontSize: 17.0),
                  ),
                ),
              ],
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  border: BorderDirectional(
                bottom: BorderSide(width: 5.0, color: const Color(0xFFca4451)),
              )),
              margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
              child: Container(
                margin: EdgeInsets.only(top: 7.0),
                child: Row(
                  children: <Widget>[
                    Container(
                        color: const Color(0xFFca4451),
                        padding: EdgeInsets.only(
                            top: 15.0, right: 15.0, left: 15.0, bottom: 10.0),
                        child: Container(
                          child: Icon(
                            Icons.whatshot,
                            color: Colors.white,
                            size: 40.0,
                          ),
                        )),
                    Container(
                      child: Container(
                        padding: EdgeInsets.only(left: 15.0),
                        child: Text(
                          "DeathMatch",
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.only(right: 10.0),
                      alignment: Alignment(1.0, 0.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: const Color(0xFFca4451),
                      ),
                    ))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, ((size.height / 4) * 3));
    path.lineTo((size.width / 2), size.height);
    path.lineTo(0.0, ((size.height / 4) * 3));
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
