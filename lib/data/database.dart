import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class Database {
  
  CollectionReference userCollectionRef;
  CollectionReference categoriesCollectionRef;

  SharedPreferences prefs;

  Database(){
    init();
  }

  init() async {
    Firestore firestore = Firestore.instance;
    firestore.settings();

    userCollectionRef = firestore.collection('Users');
    categoriesCollectionRef = firestore.collection('Categories');

    prefs = await SharedPreferences.getInstance();
  }

  Future createUserAndLogin(FirebaseUser user, String displayName, String email) async {
    User userData = User(displayName, email);

    userCollectionRef.document(user.uid).setData(userData.toMap()).whenComplete((){
      print("User: - $displayName - Added");
      addLoggedInUserToPrefs(user, displayName, email);
    }).catchError((e) => print(e));
  }

  Future getUserDisplay(FirebaseUser user, String displayName, String email) async{
    DocumentSnapshot snapshot = await userCollectionRef.document(user.uid).get();

    if(snapshot.exists){
      await userCollectionRef.document(user.uid).get()
        .then((value) => addLoggedInUserToPrefs(user, value.data['displayName'], value.data['email']));
    }else{
      createUserAndLogin(user, displayName, email);
    }
  }

  signOut(){
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signOut();

    removeLoggedInUserToPrefs();
  }

  Future<User> currentUser() async{
    String dn = await prefs.get('displayName');
    String email = await prefs.get('email');
    String id = await prefs.get('id');

    User user = new User(dn, email);
    user.setId(id);

    return user;
  }

  Future addLoggedInUserToPrefs(FirebaseUser user, String displayName, String email) async{
    await prefs.setString("displayName", displayName);
    await prefs.setString("email", email);
    await prefs.setString("id", user.uid);
  }

  Future removeLoggedInUserToPrefs() async{
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<List<DocumentSnapshot>> getQuizCategories() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("Categories").getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> getQuizCategory(String category) async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection(category).getDocuments();
    return querySnapshot.documents;
  }


}