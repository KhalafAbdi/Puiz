import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro/pages/entry/register_presenter.dart';
import '../../data/database.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>  implements RegisterPageContract{
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  RegisterPagePresenter _registerPagePresenter;
  String _displayName;
  String _email;
  String _password;

  _RegisterPageState(){
    _registerPagePresenter = RegisterPagePresenter(this);
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _registerPagePresenter.doRegister(_email, _password);
    }
  }

  @override
  void onRegisterSuccess(FirebaseUser user) {
    print("user was created ${user.email}");
    var db = new Database();

    db.createUserAndLogin(user, _displayName, _email);
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  @override
  void onRegisterError(String error) {
    print("error: $error");
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
            child: Text("Sign up",
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold))),
      ),
    ];
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(
            labelText: "Display Name",
            ),
        validator: (value) => value.isEmpty ? 'Display Name can\'t be empty' : null,
        onSaved: (value) => _displayName = value,
      ),
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
    ];
  }

  List<Widget> buildSubmitBottons() {
    return [
      themeButton("Sign Up", 20.0),
      Container(
        margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Have an account? "),
            GestureDetector(
                child: Text("Login",
                    style: TextStyle(
                        color: Color(0xFFfe2851),
                        decoration: TextDecoration.underline)),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/login')),
          ],
        ),
      )
    ];
  }

/*

*/


  Widget themeButton(title, size) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
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

