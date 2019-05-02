import 'package:flutter/material.dart';

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