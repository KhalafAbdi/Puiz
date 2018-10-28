

class User{
  String _id = "#";
  String _displayName;
  String _email;

  User(this._displayName, this._email);

  User.map(dynamic obj){
    this._id = obj['id'];
    this._displayName = obj['displayName'];
    this._email = obj['email'];
  }

  String get displayName => _displayName;
  String get email => _email;
  String get id => _id;

  void setId(String s) => _id = s; 

  Map<String,dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['displayName'] = _displayName;
    map['email'] = _email;

    return map;
  }
}