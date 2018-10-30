import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro/pages/entry/login_presenter.dart';
import 'package:pro/widgets/button.dart';
import '../../data/database.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginPageContract {
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  LoginPagePresenter _loginPagePresenter;

  String _title = "Login Page";
  String _email;
  String _password;

  _LoginPageState(){
    _loginPagePresenter = LoginPagePresenter(this);
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _loginPagePresenter.doLogin(_email, _password);
    }
  }

  void _googleSignIn(){
    print("WHY wont you work!!!");
    _loginPagePresenter.doLoginGoogle();
  }

  
  @override
  void onLoginError(String error) {
    print("error: $error");
  }

  @override
  void onLoginSuccess(FirebaseUser user) {
    print("Logged into user ${user.email} - now Looking for displayName @@@@@@@@@@@@@@@@@@@@@@@@@@@");

    var db = new Database();

    db.getUserDisplay(user, user.displayName, user.email);
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(_title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: new Container(
              child: new Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: buildInputs() + buildSubmitBottons(),
                  ))),
        ));
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(
            labelText: "Email",
            icon: const Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: const Icon(Icons.mail))),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(
            labelText: 'Password',
            icon: const Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: const Icon(Icons.lock))),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitBottons() {
    return [
      testButton("Login", 20.0),
      
      FlatButton(
          child: Text("Create an account", style: TextStyle(fontSize: 20.0)),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/register')),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Text('or', style: TextStyle(color: Colors.grey)),

        ],
      ),
      
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              child: button('Google', 'assets/google.png'),
              onPressed: _googleSignIn,
              color: Colors.white,
            ),
            MaterialButton(
              child: button('Facebook', 'assets/facebook.png', Colors.white),
              onPressed: (){},
              color: Color.fromRGBO(58, 89, 152, 1.0),
            ),
          ],
        ),
      ),
    ];
  }


  
Widget testButton(title, size) {
  return Container(
    margin: EdgeInsets.only(top:5.0),
    decoration: BoxDecoration(
        gradient: LinearGradient(
      colors: [const Color(0xFFfe7f3b), const Color(0xFFfe2851)],
      begin: FractionalOffset(0.0, 1.0),
      end: FractionalOffset(1.0, 0.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp,
    )),
    child: MaterialButton(
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontFamily: 'Roboto', fontSize: size),
        ),
        onPressed: () {
          _submit();
        }),
  );
}

}

