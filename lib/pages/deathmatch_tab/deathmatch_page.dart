import 'package:flutter/material.dart';
import 'package:pro/config/application.dart';

import 'package:pro/widgets/title_widget.dart';

import 'package:pro/data/constants.dart' as constants;


class DeathMatchPage extends StatefulWidget {
  final int index;

  DeathMatchPage(this.index);

  @override
  _DeathMatchPageState createState() => _DeathMatchPageState();
}

class _DeathMatchPageState extends State<DeathMatchPage> {
    @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: titleWidget(constants.deathMatchTitle),
          backgroundColor: constants.themeBlue
        ),
      body: buildBody(context),
      )
    );
  }

  buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, constants.themeBlue],
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(0.3, 0.15),
              stops: [1.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Easy"),
                        onPressed: () => Application.router.navigateTo(context, "/dmquiz?difficulty=easy", clearStack: true),
                      ),
                      RaisedButton(
                        child: Text("Medium"),
                        onPressed: () => Application.router.navigateTo(context, "/dmquiz?difficulty=medium", clearStack: true),
                      ),
                      RaisedButton(
                        child: Text("Hard"),
                        onPressed: () => Application.router.navigateTo(context, "/dmquiz?difficulty=hard", clearStack: true),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        color: const Color(0xFF2c304d),
                        child: MaterialButton(
                          child: Text(
                            "Random",
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Roboto', fontSize: 15.0),
                          ),
                          onPressed: () => Application.router.navigateTo(context, "/dmquiz?difficulty=random", clearStack: true),
                        ))
                    ],
                  )
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}



/*
  Get all current Death

 body: new FutureBuilder<User>(
          future: Database().currentUser(),
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

*/