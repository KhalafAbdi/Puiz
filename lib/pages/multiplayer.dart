import 'package:flutter/material.dart';

class MultiplayerPage extends StatefulWidget {
  int index;

  MultiplayerPage(this.index);

  @override
  _MultiplayerPageState createState() => _MultiplayerPageState();
}

class _MultiplayerPageState extends State<MultiplayerPage> {
      @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("M U L T I P L A Y E R",
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
                Center(child: Text("Content here!"))
              ],
            ),
          ),
        )
      ],
    );
  }
}