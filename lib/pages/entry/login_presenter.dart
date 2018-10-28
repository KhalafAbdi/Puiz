import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class LoginPageContract{
  void onLoginSuccess(FirebaseUser user);
  void onLoginError(String error);
}

class LoginPagePresenter{
  LoginPageContract _view;
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = new GoogleSignIn();
  
  LoginPagePresenter(this._view);

  doLogin(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
    .then((onValue) => _view.onLoginSuccess(onValue))
    .catchError((onError) => _view.onLoginError(onError.toString()));
  }

  doLoginGoogle() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    await _auth.signInWithGoogle(idToken: gSA.idToken, accessToken: gSA.accessToken)
      .then((onValue) => _view.onLoginSuccess(onValue))
      .catchError((onError) => _view.onLoginError(onError.toString()));
  }
}
