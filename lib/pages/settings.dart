import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro/data/database.dart';
import 'package:pro/model/user.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String myText = null;
  User user;

  void _signOut() {
    print("Test");
    var db = new Database();
    db.signOut();

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  updatepage(User user){
    setState(() {
        user = user;  
    });
  }

  void _levelUp() {
    Database().levelUp(user).then((value) => updatepage(value));
  }

  _add100Points() {
    Database().add100Points(user).then((value) => updatepage(value));
  }

  _addCoins() {}

  _removeCoins() {}

  _addGold() {}

  _removeGold() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              child: RaisedButton(
                child: Text("Sign Out"),
                onPressed: _signOut,
              ),
            ),
            new FutureBuilder<FirebaseUser>(
                future: FirebaseAuth.instance.currentUser(),
                builder: (BuildContext context,
                    AsyncSnapshot<FirebaseUser> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return new Text(snapshot.data.toString());
                  } else {
                    return new CircularProgressIndicator();
                  }
                }),
            new FutureBuilder<User>(
                future: Database().currentUser(),
                builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot != null) {
                      return Column(
                        children: <Widget>[
                          Text("ID: " + snapshot.data.id,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold)),
                          Text("Display Name: " + snapshot.data.displayName,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold)),
                          Text("Email: " + snapshot.data.email,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold)),
                        ],
                      );
                    } else {}
                  } else {
                    return new CircularProgressIndicator();
                  }
                }),
            GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this would produce 2 rows.
              crossAxisCount: 3,
              shrinkWrap: true,
              // Generate 100 Widgets that display their index in the List
              children: <Widget>[
                Center(
                  child: RaisedButton(
                    child: Text("+ One level"),
                    onPressed: () => _levelUp(),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    child: Text("+ 100 points"),
                    onPressed: () => _add100Points(),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    child: Text("Buy Coins"),
                    onPressed: () => _addCoins(),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    child: Text("Buy gold"),
                    onPressed: () => _addGold(),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    child: Text("Spend Coins"),
                    onPressed: () => _removeCoins(),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    child: Text("Add a Gold"),
                    onPressed: () => _removeGold(),
                  ),
                )
              ],
            ),
            scoreCards(context)
          ],
        ));
  }

  Widget scoreCards(BuildContext context) {
    return FutureBuilder<User>(
      future: Database().currentUser(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot != null) {
            user = snapshot.data;
            return Card(
            margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(7.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      scoreCard("Points", snapshot.data.points, true),
                      scoreCard("Level",  snapshot.data.level, true),
                      scoreCard("Coins",  snapshot.data.coins, true),
                      scoreCard("Gold",  snapshot.data.gold, false)
                    ],
                  ),
                ),
                progressToNextLevel(context)
              ],
            ),
          );
          } else {}
        } else {
          return new CircularProgressIndicator();
        }
      }
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

    int expForNextLevel = ((user.level * 50) * (user.level - 1)) + (user.level * 100);
    double percentLeft = 0.0;

    if (user.points > 0) {
      percentLeft = user.points / expForNextLevel;
    }

    print(
        "level: ${user.level}, Current xp: ${user.points}, xp to next level: $expForNextLevel, you're $percentLeft% there");

    double percent = width * percentLeft;

    Color textColor = (percentLeft > 0.60) ? Colors.white : Colors.black;

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
                    child: Text("${user.points}/$expForNextLevel",
                        style: TextStyle(
                            color: textColor,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w300)))
              ],
            ),
          )
        ],
      ),
    );
  }




}
