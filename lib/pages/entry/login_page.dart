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
    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Container(
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                begin: Alignment.topRight,
                end: Alignment(0.1, 0.0),
                colors: [const Color(0xFFca4451), const Color(0xFF2c304d)],
                stops: [1.0, 1.0],
                tileMode: TileMode.clamp,
              )),
              child: Card(
                margin: EdgeInsets.only(
                    top: 80.0, right: 15.0, left: 15.0, bottom: 15.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Container(
                      child: new Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              greeting(),
                              inputs(),
                              buildSubmitBottons()
                            ],
                          ))),
                ),
              )),
          SizedBox(
            height: 80.0,
            child: AppBar(
              backgroundColor: const Color(0x00000000),
              elevation: 0.0,
              centerTitle: true,
              title: Text("L O G I N",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300)),
            ),
          )
        ],
      ),
    );
  }

  Widget greeting() {
    return Container(
      child: Center(
        child: Icon(
          Icons.whatshot,
          color: const Color(0xFFca4451),
          size: 50.0,
        ),
      ),
    );
  }

  Widget inputs() {
    return Column(
      children: <Widget>[
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
                  color: const Color(0xFFca4451),
                  decoration: TextDecoration.underline)))
      ],
    );
  }

  Widget buildSubmitBottons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        themButton("Login", 20.0, const Color(0xFFca4451)),
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
                        color: Color(0xFFca4451),
                        decoration: TextDecoration.underline)),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/register')),
          ],
        ),
      )
      ],
    );
  }

  Widget themButton(title, size, color) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      color: color,
      child: MaterialButton(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontFamily: 'Roboto', fontSize: size, fontWeight: FontWeight.w300),
          ),
          onPressed: () {
            _submit();
          }),
    );
  }

}

