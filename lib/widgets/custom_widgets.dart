import 'package:flutter/material.dart';
import 'package:pro/data/constants.dart' as constants;

Widget backgroundWidget(mainColor, seconderyColor) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [mainColor, seconderyColor],
        begin: FractionalOffset(0.0, 1.0),
        end: FractionalOffset(0.3, 0.15),
        stops: [1.0, 1.0],
        tileMode: TileMode.clamp,
      ),
    ),
  );
}

Widget titleWidget(title, {double size = 18.0, FontWeight fontWeight = FontWeight.w300, Color color = Colors.white}) {
  return Text(title,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontWeight: fontWeight
    )
  );
}

Widget appBarWidget(String title){
  return AppBar(
    centerTitle: true,
    title: titleWidget(title),
    backgroundColor: constants.themeBlue
  );
}

Widget button(title, uri, [ color = const Color.fromRGBO(68, 68, 76, .8) ]) {
  return Container(
    
    child: Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            uri,
            width: 25.0,
          ),
          Center(
            child: Padding(
              child: Text(
              "Sign in",
              style:  TextStyle(
                fontFamily: 'Roboto',
                color: color,
              ),
            ),
              padding: new EdgeInsets.only(left: 15.0),
            ),
          ),
        ],
      ),
    ),
  );
}