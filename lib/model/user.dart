

class User{
  String _id = "#";
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

  User(this._displayName, this._email);

  User.fromDatabase(this._id,this._displayName,this._email,this._level, this._points,this._coins,this._gold,this._completedRewards,
  this._easyRecord,this._mediumRecord,this._hardRecord,this._randomRecord);

  User.map(dynamic obj){
    this._id = obj['id'];
    this._displayName = obj['displayName'];
    this._email = obj['email'];
    this._level = obj['level'];
    this._points = obj['points'];
    this._coins = obj['coins'];
    this._gold = obj['gold'];
    this._completedRewards = obj['completedRewards'];
    this._easyRecord = obj['easyRecord'];
    this._mediumRecord = obj['mediumRecord'];
    this._hardRecord = obj['hardRecord'];
    this._randomRecord = obj['randomRecord'];
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
      case "easy" : 
        _easyRecord = record;
        break;
      case "medium" :
        _mediumRecord = record;
        break;
      case "hard" :
        _hardRecord = record;
        break;
      case "random" :
        _randomRecord = record;
        break;
    }

  }

  void addPoints(int level, int currentPoints, points){
    int newPoints = currentPoints + points;
    int expForNextLevel = ((_level * 50) * (_level - 1)) + (_level * 100);

    if(newPoints >= expForNextLevel){
      levelUp(level);
    }else {
      _points = newPoints;
    }
  }

  Map<String,dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['displayName'] = _displayName;
    map['email'] = _email;
    map['level'] = _level;
    map['points'] = _points;
    map['coins'] = _coins;
    map['gold'] = _gold;
    map['completedRewards'] = _completedRewards;
    map['easyRecord'] = _easyRecord;
    map['mediumRecord'] = _mediumRecord;
    map['hardRecord'] = _hardRecord;
    map['randomRecord'] = _randomRecord;

    return map;
  }
}