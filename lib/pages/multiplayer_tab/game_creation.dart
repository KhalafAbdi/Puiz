import 'package:flutter/material.dart';
import 'dart:math';
import 'package:pro/data/database.dart';
import 'package:pro/model/user.dart';
import 'package:pro/model/game.dart';

class GameCreation extends StatefulWidget {
  @override
  _GameCreationState createState() => _GameCreationState();
}

enum Difficulty {
  easy,
  medium,
  hard, 
  any
}

class _GameCreationState extends State<GameCreation> {
  List<String> _categories = [
    'General Knowledge',
    'Books',
    'Film',
    'Music',
    'Musicals and Theatres',
    'Television',
    'Video Games',
    'Board Games',
    'Science and Nature',
    'Computers',
    'Mathematics',
    'Mythology',
    'Sports',
    'Geography',
    'History',
    'Politics',
    'Art',
    'Celebrities',
    'Animals',
    'Vehicles',
    'Comics',
    'Gadgets',
    'Japanese Anime and Manga',
    'Cartoon and Animations',
  ];


  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  List<DropdownMenuItem<String>> listDrop = [];
  String selected = null;

  String category;
  String creatorID;
  String creatorName;

  String password;

  String _flutterErrorMsg = "";
  String difficulty;

  User user;

  int _radioValue1 = -1;

  @override
    void initState() {
      super.initState();

      grabUser();
    }

  Future<void> grabUser() async{
    user = await Database().getCurrentUserData();
  }

  void _submit() {
    if(selected != null && _radioValue1 > -1){

      Game game = Game.creat(selected,difficulty,user.id, user.displayName, "open", password);

      Database().createGame(game).then((onValue) => Navigator.popAndPushNamed(context, '/multiplayerGame?gameID=${onValue.documentID}&owner=true'));
      
    }else {
      print("missing parameters");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Container(
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                begin: Alignment.topRight,
                end: Alignment(0.1, 0.0),
                colors: [ const Color(0xFF2c304d),const Color(0xFFca4451)],
                stops: [1.0, 1.0],
                tileMode: TileMode.clamp,
              )),
              child: Card(
                margin: EdgeInsets.only(
                    top: 80.0, right: 15.0, left: 15.0, bottom: 15.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Container(
                      child: new Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              greeting(),
                              buildInputs(),
                              buildSubmitBottons()
                            ],
                          ))),
                ),
              )),
             SizedBox(
            height: 80.0,
            child: AppBar(
              backgroundColor: const Color(0x00000000),
              elevation: 0.0,
              centerTitle: true,
            ),
          )
        ],
      ),
    );
  }

  Widget greeting() {
    return Container(
      child: Center(
        child: Text("Create New Game",
          style: TextStyle(
            fontSize: 18.0,
            color: const Color(0xFF2c304d),
            fontWeight: FontWeight.bold))
      ),
    );
  }



  void loadData(){
    listDrop = [];

    for(String category in _categories){
      listDrop.add(DropdownMenuItem(
        child: new Text(category),
        value: category,
      ));
    }
  }

  Widget buildInputs() {
    loadData();

    return Container(
      margin: EdgeInsets.only(top: 45.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: DropdownButton(
                    value: selected,
                    items: listDrop,
                    hint: new Text("Select Catelogy"),
                    onChanged: (value) {
                      setState(() {
                        selected = value;
                      });
                    },
                    isExpanded: true,
                  ), 
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Password"),
                            Checkbox(value: _value1, onChanged: _value1Changed),
                          ],
                        ),
                        _value1 ?
                            Row(
                            children: <Widget>[
                              Text("Your password is: $password"),
                            ],
                          ):
                        Row(
                        children: <Widget>[
                          Text("Your password is: 4444", style: TextStyle(color: Colors.white)),
                        ],
                      )
                      ],
                    ),
                   
                  ],
                ),
              ),
              
            ],
          ),
          Container(
            margin: EdgeInsets.only(top:15.0, bottom: 15.0),
            child: Text(
              'Dificulty:',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                ),
            ),
          ),

          Column(
            children: <Widget>[
              Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              new Radio(
                            value: 0,
                            groupValue: _radioValue1,
                            onChanged: _handleRadioValueChange1,
                          ),
                          new Text(
                            'Easy',
                            style: new TextStyle(fontSize: 12.0),
                          ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                               Radio(
                            value: 1,
                            groupValue: _radioValue1,
                            onChanged: _handleRadioValueChange1,
                          ),
                          new Text(
                            'Medium',
                            style: new TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              new Radio(
                              value: 2,
                              groupValue: _radioValue1,
                              onChanged: _handleRadioValueChange1,
                              ),
                              new Text(
                                'Hard',
                                style: new TextStyle(fontSize: 12.0),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              new Radio(
                                value: 3,
                                groupValue: _radioValue1,
                                onChanged: _handleRadioValueChange1,
                              ),
                              new Text(
                                'Random',
                                style: new TextStyle(fontSize: 12.0),
                              ),
                            ],
                          )
                        ],
                      ),
            ],
          )


          
        ],
      ),
    );
  }



  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;

      switch (_radioValue1) {
        case 0:
          difficulty = "easy";
          break;
        case 1:
          difficulty = "medium";
          break;
        case 2:
          difficulty = "hard";
          break;
        case 2:
          difficulty = "random";
          break;
      }
    });
  }



  bool _value1 = false;
  void _value1Changed(bool value) => setState(() {
    _value1 = value;
    password = value? randomPassword().toString() : "";
  });

  int randomPassword() {
    int min = 1000;
    int max = 9999;
    return min + (Random().nextInt(max-min));
  }




  Widget buildSubmitBottons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        
        Container(
          margin: EdgeInsets.only(top: 15.0),
          alignment: Alignment.centerRight,
          child: Text(
            _flutterErrorMsg,
            style: TextStyle(
                color: Colors.redAccent),
          ),
        ),
        
      themButton("Create Game", 20.0,const Color(0xFF2c304d)),
      ],
    );
  }

  Widget themButton(title, size, color) {
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      color: color,
      child: MaterialButton(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontFamily: 'Roboto', fontSize: size, fontWeight: FontWeight.w300),
          ),
          onPressed: () {
            _submit();
          }),
    );
  }


  
}
