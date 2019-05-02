import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pro/model/user.dart';
import 'package:pro/data/database.dart';


class HomePage extends StatefulWidget {
  int index;
  final void Function(int, String) quizPageCallBack;

  HomePage(this.index, this.quizPageCallBack);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool doneLoading = false;
  User user;

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
      body: new FutureBuilder<User>(
          future: Database().getCurrentUserData(),
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot != null) {
                user = snapshot.data;
                return buildBody(context);
              } else {}
            } else {
              return Center(child: new CircularProgressIndicator());
            }
          }),
    ));
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
                newCategoryContainer(),
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
                    user.displayName,
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
              child: Container(
              width: 125.0,
              height: 125.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(
                    user.imgPath)
                )
        ))),

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
          onPressed: () => widget.quizPageCallBack(3, null),
        ));
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
                scoreCard("Points", user.points, true),
                scoreCard("Level", user.level, true),
                scoreCard("Coins", user.coins, true),
                scoreCard("Gold", user.gold, false)
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

    /*

    Level   XP      Difference
    1       0       -
    2       100     100
    3       300     200
    4       600     300
    5       1000    400
    6       1500    500
    7       2100    600
    8       2800    700
    9       3600    800
    10      4500    900
    ...

    */

    int expForNextLevel =
        ((user.level * 50) * (user.level - 1)) + (user.level * 100);
    double percentLeft = 0.0;

    if (user.points > 0) {
      percentLeft = user.points / expForNextLevel;
    }

    print(
        "level: ${user.level}, Current xp: ${user.points}, xp to next level: $expForNextLevel, you're $percentLeft% there");

    double percent = width * percentLeft;
    print("width = $width, percent: $percent");

    Color textColor = Colors.white;

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
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFbcbcbc),
                  ),
                ),
                Container(
                  width: percent,
                  height: 30.0,
                  color: const Color(0xFFca4451),
                ),
                Container(
                    height: 30.0,
                    alignment: Alignment.center,
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Text("${user.points}/$expForNextLevel",
                            style: TextStyle(
                                color: textColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w300)),
                      ),
                    )),
                Container(
                  width: width,
                  height: 15.0,
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [Colors.black12, const Color(0x00000000)],
                        begin: Alignment.topCenter,
                        end: new Alignment(0.0, -0.4),
                        tileMode: TileMode.clamp),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget newCategoryContainer() {
    return new FutureBuilder<DocumentSnapshot>(
        future: Database().getMostRecentlyAddedQuizCategory(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot != null) {
              return newCategory(
                  snapshot.data.documentID, snapshot.data['desc']);
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        });
  }

  Widget newCategory(String title, String subText) {
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
          newCategoryCard(title, subText)
        ],
      ),
    );
  }

  Widget newCategoryCard(String title, String subText) {
    return InkWell(
      onTap: () => widget.quizPageCallBack(3, title),
      child: Container(
        margin: EdgeInsets.only(top: 7.0),
        color: const Color(0xFF5592e1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 15.0, left: 15.0, bottom: 15.0),
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
                    title,
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
                    subText,
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
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Win A ",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Roboto',
                              fontSize: 17.0),
                        ),
                        Text(
                          "DeathMatch",
                          style: TextStyle(
                              color: const Color(0xFFca4451),
                              fontFamily: 'Roboto',
                              fontSize: 17.0),
                        ),
                        Text(
                          " For Next Reward",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Roboto',
                              fontSize: 17.0),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          InkWell(
            onTap: () => widget.quizPageCallBack(2, null),
            child: Container(
                decoration: BoxDecoration(
                    border: BorderDirectional(
                  bottom:
                      BorderSide(width: 5.0, color: const Color(0xFFca4451)),
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
                )),
          )
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
