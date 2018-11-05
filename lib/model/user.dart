

class User{
  String _id = "#";
  String _displayName;
  String _email;
  
  int _level = 1;
  int _points = 0;
  int _coins = 0;
  int _gold = 0;
  int _completedRewards = 0;

  User(this._displayName, this._email);

  User.fromDatabase(this._id,this._displayName,this._email,this._level, this._points,this._coins,this._gold,this._completedRewards);

  User.map(dynamic obj){
    this._id = obj['id'];
    this._displayName = obj['displayName'];
    this._email = obj['email'];
    this._level = obj['level'];
    this._points = obj['points'];
    this._coins = obj['coins'];
    this._gold = obj['gold'];
    this._completedRewards = obj['completedRewards'];
  }

  String get displayName => _displayName;
  String get email => _email;
  String get id => _id;
  int get level => _level;
  int get points => _points;
  int get coins => _coins;
  int get gold => _gold;
  int get completedReward => _completedRewards;


  void setId(String s) => _id = s; 

  Map<String,dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['displayName'] = _displayName;
    map['email'] = _email;
    map['level'] = _level;
    map['points'] = _points;
    map['coins'] = _coins;
    map['gold'] = _gold;
    map['completedRewards'] = _completedRewards;

    return map;
  }
}