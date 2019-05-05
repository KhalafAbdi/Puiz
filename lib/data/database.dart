import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pro/model/user.dart';
import 'package:pro/model/game.dart';
import 'package:pro/model/question.dart';
import 'package:pro/model/chatmessage.dart';

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

  Future<DocumentSnapshot> getUserDocument(String userID)async{
    return await firestore.collection(constants.usersCollection).document(userID).get();
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

  Future newUser(FirebaseUser newUser, String displayName, String email) async {
    User userData = User(displayName, email);

    creatUser(newUser, userData);
    addCurrentUserInfoToPreferences(newUser, displayName, email); print("newUser called and added to shared prefs");
    setLoggedIn(true);
  }

  Future<User> getCurrentUserData() async {
    
    if(user == null){
      print("User does not exist, making new");
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

  Future addCurrentUserInfoToPreferences(FirebaseUser newUser, String displayName, String email) async{
    SharedPreferences prefs = await getSharedPreferences();

    prefs.setString(constants.sharedUserDisplayName, displayName);
    prefs.setString(constants.sharedUserMail, email);
    prefs.setString(constants.sharedUserId, newUser.uid);
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
    print("Logging out");
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

  Future<User> updateUserRecordForDifficulty(User newUser, String difficulty, int newRecord) async{
    newUser.newRecord(difficulty, newRecord);

    await firestore.collection(constants.usersCollection).document(newUser.id).setData(newUser.toMap());
    return newUser;
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

  // Get Game
  Future<DocumentSnapshot> getGame(gameID) async {
    return await firestore.collection(constants.gamesCollection).document(gameID).get();
  }

  // Create Game
  Future<DocumentReference> createGame(Game game){
    return firestore.collection(constants.gamesCollection).add(game.toMap());
  }

  // Delete Game
  deleteGame(gameID) {
    firestore.collection(constants.gamesCollection).document(gameID).delete();
  }

  // Update Game
  Future<void> updateGame(String gameID, Game updatedGame) async {
    DocumentReference documentReference = Firestore.instance.collection(constants.gamesCollection).document(gameID);
    currentGame = updatedGame;
    documentReference.updateData(updatedGame.toMap());
  }


  Future<List<Game>> getLiveGames() async {
    var querySnapshot = await Firestore.instance.collection(constants.gamesCollection).where(constants.gameState, isEqualTo: constants.gameStateOpen).getDocuments();
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

  Future<bool> joinGame(Game game) async{
    String gameState = await getGameState(game.gameID);
    if(gameState == constants.gameStateOpen){

      
      User user = await getUser();

      game.state = constants.gameStateClosed;
      game.joinerID = user.id;
      game.joinerName = user.displayName;

      firestore.collection(constants.gamesCollection).document(game.gameID).updateData(game.toMap());

      return true;
    }else {
      return false;
    }  
  }

  Future<String> getGameState(String gameID) async{
    DocumentSnapshot documentSnapshot = await firestore.collection(constants.gamesCollection).document(gameID).get();

    print("res: ${documentSnapshot.data[constants.gameState].toString()}");
    return documentSnapshot.data[constants.gameState].toString();
  }

  // ------------------------------------- Messages Collection -------------------------------------
  bool isCreator = false;
  User player;
  User opponent;
  Game currentGame;
  List<Question> questions = [];

  Future<void> setUpGame(String gameID) async {
    
    questions = [];
    await buildGame(gameID);
    await getQuestions(gameID);  
    player = await getPlayer();
    opponent = await getOpponent(gameID);
  }

  Future<Game> buildGame(String gameID, {String state = constants.gameState}) async {
    
    DocumentSnapshot documentSnapshot = await getGame(gameID);

    Game game = Game.start(
      documentSnapshot.documentID,
      documentSnapshot.data[constants.gameCategory],
      documentSnapshot.data[constants.gameDifficulty],
      documentSnapshot.data[constants.gameCreatorID],
      documentSnapshot.data[constants.gameCreatorName],
      documentSnapshot.data[state],
      documentSnapshot.data[constants.gameJoinerID],
      documentSnapshot.data[constants.gameJoinerName],
    );

    return game;
  }

  Future<Game> buildandReturnGame(String gameID) async {
    DocumentSnapshot documentSnapshot = await Database().getGame(gameID);

    Game newGame = Game(
          documentSnapshot.documentID,
          documentSnapshot.data[constants.gameCategory],
          documentSnapshot.data[constants.gameDifficulty],
          documentSnapshot.data[constants.gameCreatorID],
          documentSnapshot.data[constants.gameCreatorName],
          documentSnapshot.data[constants.gameState],
          documentSnapshot.data[constants.gamePassword],
      );  

    return newGame;
  }


  getIsCreator() {
    return isCreator;
  }

  Future<User> getPlayer() async {
    if(player == null){
      player = await Database().getCurrentUserData();
    }
    
    return player;
  }

  Future<User> getOpponent(String gameID) async {
    String opponentID;

    if(opponent == null){

      DocumentSnapshot gameSnapshot = await getGame(gameID);
      player = await getPlayer();

      if(player.displayName == gameSnapshot.data[constants.gameCreatorName].toString()){
        isCreator = true;
        opponentID = gameSnapshot.data[constants.gameJoinerID].toString();
      }else {
        opponentID = gameSnapshot.data[constants.gameCreatorID].toString();
      }

      opponent = await Database().getUser(opponentID);
    }
    
    return opponent;
  }

  Future<Game> getCurrentGame(String gameID) async {
    
    if(currentGame == null){
      currentGame = await buildGame(gameID);
      return currentGame;
    }

    return currentGame;
  }

  Future<void> createQuestions(String gameID, Question newQuestion, int index) async {
    firestore.collection(constants.messagesCollection).document(gameID).collection(constants.questionsCollection).document("question_${index+1}").setData(newQuestion.toMap());
  }

  Future<void> setGameFields(String gameID, var map){
    Firestore.instance.collection(constants.messagesCollection).document(gameID).setData(map);
  }

  Future<List<Question>> getQuestions(String gameID) async {
    if(questions.isEmpty){
      QuerySnapshot questionsQuery = await firestore.collection(constants.messagesCollection).document(gameID).collection(constants.questionsCollection).getDocuments();

      for (DocumentSnapshot item in questionsQuery.documents) {
        
        List<String> list = [];
        list.addAll(item.data[constants.responseQuestionIncorrectAnswers].cast<String>());

        Question question = new Question(
          question: item.data[constants.responseQuestion],
          correctAnswer: item.data[constants.responseQuestionCorrectAnswer],
          incorrectAnswers: list
        );

        questions.add(question);
      }
    }

    return questions;
  }

  Stream<DocumentSnapshot> getCurrentGameFields(String gameID) {
    return firestore.collection(constants.gamesCollection).document(gameID).snapshots();
  }

  Stream<DocumentSnapshot> getCurrentGameStats(String gameID) {
    return firestore.collection(constants.messagesCollection).document(gameID).snapshots();
  }

  Stream<QuerySnapshot> getCurrentGameChatMessages(String gameID) {
    return firestore.collection(constants.messagesCollection).document(gameID).collection(constants.chatCollections).snapshots();
  }

  Stream<DocumentSnapshot> getQuestionInCurrentGame(String gameID, int index) {
    String questionPath = 'question_${index+1}';

    return firestore.collection(constants.messagesCollection).document(gameID).collection(constants.questionsCollection).document(questionPath).snapshots();
  }

  Future<void> updateGameData(String gameID, int index, Question q){
     String questionPath = 'question_${index+1}';

    firestore.collection(constants.messagesCollection).document(gameID).collection(constants.questionsCollection).document(questionPath).setData(q.toMap());
  }


  Future<void> addMessage(String gameID, ChatMessage message) async {
    await firestore.collection(constants.messagesCollection).document(gameID).collection(constants.chatCollections).add(message.toMap());
  }
}