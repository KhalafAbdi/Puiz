import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class Database {
  CollectionReference userCollectionRef;
  SharedPreferences prefs;
  User user;

  Database(){
    init();
  }

  init() async {
    Firestore firestore = Firestore.instance;
    firestore.settings();

    userCollectionRef = firestore.collection('Users');

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

  }

  Future<User> currentUser() async{
    prefs = await SharedPreferences.getInstance();
    String id = prefs.get("id");

    DocumentSnapshot snapshot = await userCollectionRef.document(id).get();

    User user = User.fromDatabase(
      id, 
      snapshot.data['displayName'], 
      snapshot.data['email'], 
      snapshot.data['level'], 
      snapshot.data['points'], 
      snapshot.data['coins'], 
      snapshot.data['gold'], 
      snapshot.data['completedRewards']
    );

    return user;
  }

  Future<DocumentSnapshot> getNewestCategory() async{
    Firestore firestore = Firestore.instance;
    firestore.settings();

    DocumentSnapshot snapshot = await firestore.collection('Categories').document('Newest Category').get();
    String title = snapshot.data['title'];

    return await firestore.collection('Categories').document(title).get();
  }

  Future isThisFirstLaunch(String id) async {
    prefs = await SharedPreferences.getInstance();
    String s = prefs.get(id);

    print("Is this the first time logging in $s");
    return null;
  }

  Future addLoggedInUserToPrefs(FirebaseUser user, String displayName, String email) async{
    await prefs.setString("displayName", displayName);
    await prefs.setString("email", email);
    await prefs.setString("id", user.uid);
  }

  Future<List<DocumentSnapshot>> getQuizCategories() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("Categories").getDocuments();
    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> getQuizCategory(String category) async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection(category).getDocuments();
    return querySnapshot.documents;
  }

  Future<User> levelUp(User user) async{
    prefs = await SharedPreferences.getInstance();
    String id = prefs.get("id");

    DocumentSnapshot snapshot = await userCollectionRef.document(id).get();
    int level = snapshot.data["level"];

    user.levelUp(level);

    userCollectionRef.document(id).setData(user.toMap());
    return user;
  }

  Future<User> add100Points(User user) async{
    prefs = await SharedPreferences.getInstance();
    String id = prefs.get("id");

    DocumentSnapshot snapshot = await userCollectionRef.document(id).get();
    int level = snapshot.data["level"];
    int points = snapshot.data["points"];

    user.addPoints(level, points);

    userCollectionRef.document(id).setData(user.toMap());
    return user;
  }


}