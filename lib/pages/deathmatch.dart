import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pro/config/application.dart';


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
        title: Text("D E A T H M A T C H",
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.w300)),
        backgroundColor: const Color(0xFF2c304d),
      ),
      body: buildBody(context),
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
            margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      Text("Whats good"),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        color: const Color(0xFF2c304d),
                        child: MaterialButton(
                          child: Text(
                            "Random",
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Roboto', fontSize: 15.0),
                          ),
                          onPressed: () => Application.router.navigateTo(context, "/dmquiz?difficulty=Random", clearStack: true),
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