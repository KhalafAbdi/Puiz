import 'package:pro/data/constants.dart' as constants;
import 'avatar.dart';


class User{
  String _id = '';
  String imgPath = '';
  String _displayName;
  String _email;
  
  int _level = 1;
  int _points = 0;
  int _coins = 0;
  int _gold = 0;
  int _completedRewards = 0;

  int _easyRecord = 0;
  int _mediumRecord = 0;
  int _hardRecord = 0;
  int _randomRecord = 0;

  User(this._displayName, this._email){
    imgPath = Avatar().getRandom();
  }

  User.fromDatabase(this._id,this._displayName,this._email,this._level, this._points,this._coins,this._gold,this._completedRewards,
  this._easyRecord,this._mediumRecord,this._hardRecord,this._randomRecord, this.imgPath);

  User.public(this._id,this._displayName,this._level, this.imgPath);

  User.map(dynamic obj){
    this._id = obj[constants.userID];
    this._displayName = obj[constants.userDisplayName];
    this._email = obj[constants.userMail];
    this._level = obj[constants.userLevel];
    this._points = obj[constants.userPoints];
    this._coins = obj[constants.userCoins];
    this._gold = obj[constants.userGold];
    this._completedRewards = obj[constants.userCompletedRewards];
    this._easyRecord = obj[constants.userEasyRecord];
    this._mediumRecord = obj[constants.userMediumRecord];
    this._hardRecord = obj[constants.userHardRecord];
    this._randomRecord = obj[constants.userRandomRecord];
    this.imgPath = obj[constants.userImgPath];
  }

  String get displayName => _displayName;
  String get email => _email;
  String get id => _id;
  int get level => _level;
  int get points => _points;
  int get coins => _coins;
  int get gold => _gold;
  int get completedReward => _completedRewards;

  int get easyRecord => _easyRecord;
  int get mediumRecord => _mediumRecord;
  int get hardRecord => _hardRecord;
  int get randomRecord => _randomRecord;

  void setId(String s) => _id = s; 

  void levelUp(int level) {
    _level = level + 1;
    _points = 0;
  }

  void newRecord(String difficulty, int record){

    switch(difficulty){
      case constants.difficultyEasy : 
        _easyRecord = record;
        break;
      case constants.difficultyMedium :
        _mediumRecord = record;
        break;
      case constants.difficultyHard :
        _hardRecord = record;
        break;
      case constants.difficultyRandom :
        _randomRecord = record;
        break;
    }

  }

  void addPoints(int level, int currentPoints, points){
    int newPoints = currentPoints + points;
    int expForNextLevel = ((_level * 50) * (_level - 1)) + (_level * 100);

    if(newPoints >= expForNextLevel){
      int remainer = newPoints - expForNextLevel;
      _points = remainer;
      levelUp(level);
    }else {
      _points = newPoints;
    }
  }

  Map<String,dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map[constants.userDisplayName] = _displayName;
    map[constants.userMail] = _email;
    map[constants.userLevel] = _level;
    map[constants.userPoints] = _points;
    map[constants.userCoins] = _coins;
    map[constants.userGold] = _gold;
    map[constants.userCompletedRewards] = _completedRewards;
    map[constants.userEasyRecord] = _easyRecord;
    map[constants.userMediumRecord] = _mediumRecord;
    map[constants.userHardRecord] = _hardRecord;
    map[constants.userRandomRecord] = _randomRecord;
    map[constants.userImgPath] = imgPath;

    return map;
  }

  String to(){
    return _displayName;
  }
}





