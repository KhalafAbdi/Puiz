import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pro/model/user.dart';
import 'package:pro/model/game.dart';

import 'package:pro/data/constants.dart' as constants;

class Database {
  //bool isLoggedIn = false;

  SharedPreferences preferences;
  Firestore firestore;
  User user;

  Database(){
    init();
  }

  init() async {
    firestore = Firestore.instance;
    firestore.settings();
  }

  Future<SharedPreferences> getSharedPreferences() async {
    if(preferences == null){
      preferences = await SharedPreferences.getInstance();
    }

    return preferences;
  }

// ------------------------------------- User -------------------------------------

  //Get User
  Future<User> getUser([String userID]){
    if(userID == null){
      return getCurrentUserData();
    }else {
      return getOpponentData(userID);
    }
  }

  //Create user
  Future<void> creatUser(FirebaseUser user, User newUser) async {
    await firestore.collection(constants.usersCollection).document(user.uid).setData(newUser.toMap());
  }

  //Update user
  Future<void> updateUser(User user) async{
    await firestore.collection(constants.usersCollection).document(user.id).updateData(user.toMap());
  }

  //Delete user
  Future<void> deleteUser(User user) async{
    await firestore.collection(constants.usersCollection).document(user.id).delete();
  }

  Future newUser(FirebaseUser user, String displayName, String email) async {
    User userData = User(displayName, email);

    creatUser(user, userData);
    addCurrentUserInfoToPreferences(user, displayName, email);
    setLoggedIn(true);
  }

  Future<User> getCurrentUserData() async {
    
    if(user == null){
      SharedPreferences prefs = await getSharedPreferences();
      String userID = prefs.get(constants.sharedUserId);
      
      DocumentSnapshot snapshot = await firestore.collection(constants.usersCollection).document(userID).get();
      user = User.fromDatabase(
        userID, 
        snapshot.data[constants.userDisplayName], 
        snapshot.data[constants.userMail], 
        snapshot.data[constants.userLevel], 
        snapshot.data[constants.userPoints], 
        snapshot.data[constants.userCoins], 
        snapshot.data[constants.userGold], 
        snapshot.data[constants.userCompletedRewards],
        snapshot.data[constants.userEasyRecord],
        snapshot.data[constants.userMediumRecord],
        snapshot.data[constants.userHardRecord],
        snapshot.data[constants.userRandomRecord],
        snapshot.data[constants.userImgPath]
      );
    }

    return user;
  }

  Future<User> getOpponentData(String opponentID) async{
    DocumentSnapshot snapshot = await firestore.collection(constants.usersCollection).document(opponentID).get();

    return User.public(
      opponentID, 
      snapshot.data[constants.userDisplayName],  
      snapshot.data[constants.userLevel], 
      snapshot.data[constants.userImgPath]
    );
  }

  Future addCurrentUserInfoToPreferences(FirebaseUser user, String displayName, String email) async{
    SharedPreferences prefs = await getSharedPreferences();

    prefs.setString(constants.sharedUserDisplayName, displayName);
    prefs.setString(constants.sharedUserMail, email);
    prefs.setString(constants.sharedUserId, user.uid);
  }

  Future getUserData(FirebaseUser user, String displayName, String email) async{
    DocumentSnapshot snapshot = await firestore.collection(constants.usersCollection).document(user.uid).get();

      if(snapshot.exists){
        addCurrentUserInfoToPreferences(user, displayName, email);
        setLoggedIn(true);
      }else{
        newUser(user, displayName, email);
      }
  }


  setLoggedIn(bool isLoggedIn) async{
    SharedPreferences prefs = await getSharedPreferences();

    prefs.setBool(constants.sharedIsLoggedIn, isLoggedIn);
  }

  Future<bool> isUserLoggedIn()async{
    SharedPreferences prefs = await getSharedPreferences();

    return prefs.getKeys().contains(constants.sharedIsLoggedIn) ? prefs.getBool(constants.sharedIsLoggedIn) : false;
  }

  signOut(){
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.signOut();
    setLoggedIn(false);
  }


  //User Actions
  Future<void> levelUpUser(User user) async{
    DocumentSnapshot snapshot = await firestore.collection(constants.usersCollection).document(user.id).get();
    int level = snapshot.data[constants.userLevel];

    user.levelUp(level);

    await firestore.collection(constants.usersCollection).document(user.id).setData(user.toMap());
  }

  Future<void> addPoints(User user, int points) async{
    DocumentSnapshot snapshot = await firestore.collection(constants.usersCollection).document(user.id).get();
    int level = snapshot.data[constants.userLevel];
    int currentPoints = snapshot.data[constants.userPoints];

    user.addPoints(level, currentPoints, points);

    await firestore.collection(constants.usersCollection).document(user.id).setData(user.toMap());
  }

  Future<User> updateUserRecordForDifficulty(User user, String difficulty, int newRecord) async{
    user.newRecord(difficulty, newRecord);

    await firestore.collection(constants.usersCollection).document(user.id).setData(user.toMap());
    return user;
  }

// ------------------------------------- Categories -------------------------------------

  Future<DocumentSnapshot> getMostRecentlyAddedQuizCategory() async{
    DocumentSnapshot snapshot = await firestore.collection(constants.categoriesCollection).document(constants.newestCategoryCollection).get();
    return await firestore.collection(constants.categoriesCollection).document(snapshot.data['title']).get();
  }

  // Get Category
  Future<List<DocumentSnapshot>> getQuizCategory(String category) async {
    QuerySnapshot querySnapshot = await firestore.collection(category).getDocuments();
    return querySnapshot.documents;
  }

  // Get Categories    
  Future<List<DocumentSnapshot>> getQuizCategories() async {
    QuerySnapshot querySnapshot = await firestore.collection(constants.categoriesCollection).getDocuments();
    return querySnapshot.documents;
  }



// ------------------------------------- Multiplayer Games -------------------------------------

  // Create Game
  Future<DocumentReference> createGame(Game game){
    return firestore.collection(constants.gamesCollection).add(game.toMap());
  }

  // Delete Game
  deleteGame(gameID) {
    firestore.collection(constants.gamesCollection).document(gameID).delete();
  }

  // Update Game
   // TODO: update game


  Future<List<Game>> getLiveGames() async {
    var querySnapshot = await firestore.collection(constants.gamesCollection).where(constants.gameState, isEqualTo: constants.gameStateOpen).getDocuments();
    List<DocumentSnapshot> d = querySnapshot.documents;

    List<Game> games = [];

    for(DocumentSnapshot snapshot in d){
  
      games.add(
        Game(
          snapshot.documentID,
          snapshot.data[constants.gameCategory],
          snapshot.data[constants.gameDifficulty],
          snapshot.data[constants.gameCreatorID],
          snapshot.data[constants.gameCreatorName],
          snapshot.data[constants.gameState],
          snapshot.data[constants.gamePassword],
          )
      );   

    }
    return games;
  }

  joinGame(Game game) async{
    String gameState = await getGameState(game.gameID);
    if(gameState == constants.gameStateOpen){

      
      User user = await getUser();

      game.state = constants.gameStateClosed;
      game.joinerID = user.id;
      game.joinerName = user.displayName;

      firestore.collection(constants.gamesCollection).document(game.gameID).updateData(game.toMap());
    }else {
      //TODO: Game is no longer open.
    }  
  }

  Future<String> getGameState(String gameID) async{
    DocumentSnapshot documentSnapshot = await firestore.collection(constants.gamesCollection).document(gameID).get();

    print("res: ${documentSnapshot.data[constants.gameState].toString()}");
    return documentSnapshot.data[constants.gameState].toString();
  }
}