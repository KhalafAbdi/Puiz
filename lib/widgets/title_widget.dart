import 'package:flutter/material.dart';

Widget titleWidget(title, {double size = 18.0, FontWeight fontWeight = FontWeight.w300, Color color = Colors.white}) {
  return Text(title,
    style: TextStyle(
      fontSize: size,
      color: color,
      fontWeight: fontWeight
    )
  );
}