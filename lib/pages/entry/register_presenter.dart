import 'package:firebase_auth/firebase_auth.dart';

abstract class RegisterPageContract{
  void onRegisterSuccess(FirebaseUser user);
  void onRegisterError(String error);
}

class RegisterPagePresenter{
  RegisterPageContract _view;
  
  RegisterPagePresenter(this._view);

  doRegister(String email, String password) async {
    await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password)
      .then((onValue) => _view.onRegisterSuccess(onValue))
      .catchError((onError) => _view.onRegisterError(onError.toString()));
  }
}
