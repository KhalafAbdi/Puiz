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
                   return new CircularProgressIndicator();
                }
              }
          ), 
          new FutureBuilder<User>(
            future: Database().currentUser(),
            builder: (BuildContext context,
              AsyncSnapshot<User> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot != null){
                    return Column(
                    children: <Widget>[
                      Text("ID: " + snapshot.data.id, style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                      Text("Display Name: " + snapshot.data.displayName, style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                      Text("Email: " + snapshot.data.email, style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                    ],
                  );
                  }else {

                  }
                } else {
                   return new CircularProgressIndicator();
                }
              }
          ), 
        ],
      )
    );
  }

}