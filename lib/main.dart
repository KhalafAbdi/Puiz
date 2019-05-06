import 'package:flutter/material.dart';
import 'package:pro/config/app_component.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(new AppComponent());
    });
}

