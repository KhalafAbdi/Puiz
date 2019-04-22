import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';
import '../model/game.dart';

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
    
  }

  // ------------------ USER -----------------------
  Future<bool> isLoggedIn()async{
    prefs = await SharedPreferences.getInstance();
    bool t = (prefs.getKeys().contains("isLoggedin")) ? prefs.getBool("isLoggedin") : null;
    print("isLoggedIn returned $t");
    return (t == null) ? false : true;
  }

  login() async{
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedin", true);
    print("Login has been called, which should now be ${ prefs.getBool("isLoggedin")}");
  }

  logout() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedin", false);
  }

  Future createUserAndLogin(FirebaseUser user, String displayName, String email) async {
    User userData = User(displayName, email);

    userCollectionRef.document(user.uid).setData(userData.toMap()).whenComplete((){
      addLoggedInUserToPrefs(user, displayName, email);
    }).catchError((e) => print(e));

    login();
  }

  Future getUserDisplay(FirebaseUser user, String displayName, String email) async{
    DocumentSnapshot snapshot = await userCollectionRef.document(user.uid).get();

    if(snapshot.exists){
      await userCollectionRef.document(user.uid).get().then((value) => addLoggedInUserToPrefs(user, value.data['displayName'], value.data['email']));
      login();
    }else{
      createUserAndLogin(user, displayName, email);
    }
  }

  signOut(){
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signOut();
    logout();
  }


  // ------------------ CATEGORIES -----------------------

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
      snapshot.data['completedRewards'],
      snapshot.data['easyRecord'],
      snapshot.data['mediumRecord'],
      snapshot.data['hardRecord'],
      snapshot.data['randomRecord']
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
    prefs = await SharedPreferences.getInstance();

    prefs.setString("displayName", displayName);
    prefs.setString("email", email);
    prefs.setString("id", user.uid);
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

  Future<User> addPoints(User user, int points) async{
    prefs = await SharedPreferences.getInstance();
    String id = prefs.get("id");

    DocumentSnapshot snapshot = await userCollectionRef.document(id).get();
    int level = snapshot.data["level"];
    int currentPoints = snapshot.data["points"];

    user.addPoints(level, currentPoints, points);

    userCollectionRef.document(id).setData(user.toMap());
    return user;
  }

  Future<User> updateCurrentRecord(User user, String difficulty, int newRecord) async{
    prefs = await SharedPreferences.getInstance();
    String id = prefs.get("id");

    user.newRecord(difficulty, newRecord);

    userCollectionRef.document(id).setData(user.toMap());
    return user;
  }

  Future<DocumentReference> createGame(Game game){
    Firestore firestore = Firestore.instance;
    firestore.settings();


    CollectionReference gameCollection = firestore.collection('Games');



    return gameCollection.add(game.toMap());

    

  }

  Future<List<Game>> getOpenGames()async{
    print("GetOpenGames called");
    var respectsQuery = Firestore.instance.collection('Games').where('state', isEqualTo: 'open');
    var querySnapshot = await respectsQuery.getDocuments();
    List<DocumentSnapshot> d = querySnapshot.documents;

    List<Game> games = [];

    for(DocumentSnapshot snapshot in d){
      

      games.add(
        Game(
          snapshot.documentID,
          snapshot.data['category'],
          snapshot.data['difficulty'],
          snapshot.data['creatorID'],
          snapshot.data['creatorName'],
          snapshot.data['state'],
          snapshot.data['password'],
          )
      );     
    }
    return games;
  }

  deleteGame(gameID) {
    Firestore firestore = Firestore.instance;
    firestore.settings();

    firestore.collection('Games').document(gameID).delete().then((v) => print("Delete success "));
  }

  joinGame(Game game) async{
    DocumentReference documentReference = Firestore.instance.collection('Games').document(game.gameID);

    game.state = "closed";
    User cUser = await currentUser();

    game.joinerID = cUser.id;
    game.joinerName = cUser.displayName;

    documentReference.updateData(game.toMap());
  }

  Future<String> getGameState(Game game) async{
    print("getGameState called");
    DocumentReference documentReference = Firestore.instance.collection('Games').document(game.gameID);
    DocumentSnapshot documentSnapshot = await documentReference.get();

    print("res: ${documentSnapshot.data['state'].toString()}");
    return documentSnapshot.data['state'].toString();
  }



}