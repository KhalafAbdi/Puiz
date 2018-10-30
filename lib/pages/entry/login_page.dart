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
  LoginPagePresenter _loginPagePresenter;

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _email;
  String _password;

  _LoginPageState() {
    _loginPagePresenter = LoginPagePresenter(this);
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _loginPagePresenter.doLogin(_email, _password);
    }
  }

  void _googleSignIn() {
    _loginPagePresenter.doLoginGoogle();
  }

  @override
  void onLoginError(String error) {
    print("error: $error");
  }

  @override
  void onLoginSuccess(FirebaseUser user) {
    var db = new Database();

    db.getUserDisplay(user, user.displayName, user.email);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Container(
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                begin: FractionalOffset(0.0, 1.0),
                end: FractionalOffset(1.0, 0.0),
                colors: [
                  const Color(0xFFfe7f3b),
                  const Color(0xFFfe2851),
                ],
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
              child: Container(
                margin: EdgeInsets.only(
                    top: 80.0, right: 8.0, left: 8.0, bottom: 8.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.circular(5.0)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Container(
                      child: new Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: buildTop() +
                                buildInputs() +
                                buildSubmitBottons(),
                          ))),
                ),
              )),
            SizedBox(
              height:80.0,
              child: AppBar(
              backgroundColor: const Color(0x00000000),
              elevation: 0.0,
            ),
            )
        ],
      ),
    );
  }

  List<Widget> buildTop() {
    return [
      Center(child: FlutterLogo(textColor: Colors.white, size: 50.0)),
      Container(
        margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
        child: Center(
            child: Text("Welcome Back",
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic))),
      ),
      Container(
          margin: EdgeInsets.only(bottom: 25.0),
          child: Center(
              child: Text("Login with your email to start",
                  style:
                      TextStyle(fontSize: 10.0, fontStyle: FontStyle.italic)))),
    ];
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(
            labelText: "Email",
            ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(
            labelText: 'Password',
            ),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
      Container(
          margin: EdgeInsets.only(top: 30.0, bottom: 15.0),
          alignment: Alignment(1.0, 0.0),
          child: Text("Forgot password?",
              style: TextStyle(
                  color: Color(0xFFfe2851),
                  decoration: TextDecoration.underline)))
    ];
  }

  List<Widget> buildSubmitBottons() {
    return [
      themeButton("Login", 20.0),
      Container(
        margin: EdgeInsets.symmetric(vertical: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(child: Container(child: Divider())),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text('or', style: TextStyle(color: Colors.grey))),
            Expanded(child: Container(child: Divider())),
          ],
        ),
      ),
      Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                child: button('Google', 'assets/google.png'),
                onPressed: _googleSignIn,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.0),
            ),
            Expanded(
              child: MaterialButton(
                child: button('Facebook', 'assets/facebook.png', Colors.white),
                onPressed: () {},
                color: Color.fromRGBO(58, 89, 152, 1.0),
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Don't have an account? "),
            GestureDetector(
                child: Text("Sign up",
                    style: TextStyle(
                        color: Color(0xFFfe2851),
                        decoration: TextDecoration.underline)),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/register')),
          ],
        ),
      )
    ];
  }

  Widget themeButton(title, size) {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
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
