import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro/data/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String myText = null;

  void _signOut() {
    var db = new Database();
    db.signOut();

    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

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
                   return new Text('Loading...');
                }
              }
          ), 
          new FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (BuildContext context,
              AsyncSnapshot<SharedPreferences> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: <Widget>[
                      Text("ID: " + snapshot.data.get("id"), style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                      Text("Display Name: " + snapshot.data.get("displayName"), style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                      Text("Email: " + snapshot.data.get("email"), style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                    ],
                  );
                } else {
                   return new Text('Loading...');
                }
              }
          ), 
        ],
      )
    );
  }

}