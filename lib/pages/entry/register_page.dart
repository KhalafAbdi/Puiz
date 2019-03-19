import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro/pages/entry/register_presenter.dart';
import '../../data/database.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    implements RegisterPageContract {
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  RegisterPagePresenter _registerPagePresenter;
  String _displayName;
  String _email;
  String _password;


  _RegisterPageState() {
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
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/onBoarding', (Route<dynamic> route) => false);
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
                begin: Alignment.topRight,
                end: Alignment(0.1, 0.0),
                colors: [ const Color(0xFF2c304d),const Color(0xFFca4451)],
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
                              buildInputs(),
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
              title: Text("R E G I S T E R",
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
          color: const Color(0xFF2c304d),
          size: 50.0,
        ),
      ),
    );
  }

  Widget buildInputs() {
    return Column(
      children: <Widget>[
        TextFormField(
        decoration: InputDecoration(
            labelText: "Display Name",
            ),
        validator: (value) => _displayNameValidate(value),
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
      ],
    );
  }

  _displayNameValidate(String value) {
    String res;

    if(value.isEmpty){
      res = 'Display Name can\'t be empty';
    }else {
      res = null;
    }

    return res;
  }




  Widget buildSubmitBottons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        themButton("Register", 20.0,const Color(0xFF2c304d)),
      Container(
        margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Have an account? "),
            GestureDetector(
                child: Text("Login",
                    style: TextStyle(
                        color: Color(0xFFca4451),
                        decoration: TextDecoration.underline)),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/login')),
          ],
        ),
      )
      ],
    );
  }

  Widget themButton(title, size, color) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
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
