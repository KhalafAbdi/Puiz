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

  String _title = "Register Page";
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
            labelText: "Display Name",
            icon: const Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: const Icon(Icons.person))),
        validator: (value) => value.isEmpty ? 'Display Name can\'t be empty' : null,
        onSaved: (value) => _displayName = value,
      ),
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
      RaisedButton(
        color: Colors.lightBlue,
        child: Text("Create an account", style: TextStyle(fontSize: 20.0)),
        onPressed: _submit,
      ),
      FlatButton(
        child: Text("Have an account? Login", style: TextStyle(fontSize: 20.0)),
        onPressed: () => Navigator.pushReplacementNamed(context, '/login')
      )
    ];
  }

}

