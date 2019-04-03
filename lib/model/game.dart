class Game{
  String gameID;

  String category;
  String difficulty;

  String creatorID;
  String creatorName;

  String joiner;
  String joinerID;

  String state;
  bool hasPassword;

  String password;

  Game(this.gameID,this.category, this.difficulty, this.creatorID, this.creatorName, this.state, this.hasPassword);

  Game.creat(this.category, this.difficulty, this.creatorID,this.creatorName, this.password);

  Map<String,dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['category'] = category;
    map['difficulty'] = difficulty;
    map['creatorID'] = creatorID;
    map['creatorName'] = creatorName;
    map['state'] = "open";
    map['password'] = password;

    return map;
  }

  bool contains(String query) {

    if(category.toLowerCase().contains(query.toLowerCase()) || creatorName.toLowerCase().contains(query.toLowerCase()) || difficulty.toLowerCase().contains(query.toLowerCase())){
      return true;
    }

    return false;
  }
}

