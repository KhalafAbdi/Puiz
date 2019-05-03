import 'package:flutter/material.dart';
import 'package:pro/config/application.dart';

import 'package:pro/widgets/custom_widgets.dart' as customWidget;

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
        resizeToAvoidBottomPadding: false,
        appBar: customWidget.appBarWidget(constants.deathMatchTitle),
        body: buildBody(context),
      )
    );
  }

  buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        customWidget.backgroundWidget(Colors.white, constants.themeRed),
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
                        child: Text(constants.difficultyEasy),
                        onPressed: () => Application.router.navigateTo(context, "/dmquiz?difficulty=${constants.difficultyEasy.toLowerCase()}", clearStack: true),
                      ),
                      RaisedButton(
                        child: Text(constants.difficultyMedium),
                        onPressed: () => Application.router.navigateTo(context, "/dmquiz?difficulty=${constants.difficultyMedium.toLowerCase()}", clearStack: true),
                      ),
                      RaisedButton(
                        child: Text(constants.difficultyHard),
                        onPressed: () => Application.router.navigateTo(context, "/dmquiz?difficulty=${constants.difficultyHard.toLowerCase()}", clearStack: true),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        color: const Color(0xFF2c304d),
                        child: MaterialButton(
                          child: Text(
                            constants.difficultyRandom,
                            style: TextStyle(color: Colors.white, fontFamily: constants.font, fontSize: 15.0),
                          ),
                          onPressed: () => Application.router.navigateTo(context, "/dmquiz?difficulty=${constants.difficultyRandom.toLowerCase()}", clearStack: true),
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