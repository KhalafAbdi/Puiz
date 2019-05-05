import 'package:flutter/material.dart';
import 'package:pro/data/database.dart';
import 'package:pro/model/user.dart';
import 'package:pro/model/game.dart';

import 'package:pro/widgets/custom_widgets.dart' as customWidget;
import 'package:fluttertoast/fluttertoast.dart';

class MultiplayerPage extends StatefulWidget {
  final int index;

  MultiplayerPage(this.index);

  @override
  _MultiplayerPageState createState() => _MultiplayerPageState();
}

class _MultiplayerPageState extends State<MultiplayerPage> {

  TextEditingController searchInputController = TextEditingController();
  TextEditingController passwordFieldControler = TextEditingController();

  String filter;

  User user;

  List<Game> games = [];
  int liveGames = 0;

  bool doneLoading = false;
  
  @override
    void initState() {
      super.initState();

      searchInputController.addListener(() {
        setState(() {
          filter = searchInputController.text;
        });
      });
      print("starting multiplayer page");
      fetchOpenGames();
    }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
      appBar: customWidget.appBarWidget('M U L T I P L A Y E R'),
      body: buildBody(context),
    ));
  }

  buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        customWidget.backgroundWidget(Colors.white, const Color(0xFFca4451)),
        
        Container(
            margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                  customSearchBox(),

                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: doneLoading ? listOpenGames() : Center(child: new CircularProgressIndicator())
                    ),
                  )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15.0, right: 15.0),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFFca4451),
              foregroundColor:  Colors.white,
              child:  Icon(Icons.add),
              onPressed: () {
                  Navigator.pushNamed(context, '/createNewGame');
                },
          ),
          )  
      ],
    );
  }

  Widget customSearchBox(){
    return Container(
        margin: EdgeInsets.only(top:15.0, bottom: 30.0),
        height: 57.0,
        width: MediaQuery.of(context).size.width/1.2,
        child: Padding(
          padding: EdgeInsets.only(left:30.0,top:5.0),
          child: TextField(
          controller: searchInputController,
          cursorColor: Color(0xFF2c304d),
          style: TextStyle(fontSize: 16.0, color: Color(0xFF2c304d), fontWeight: FontWeight.w300),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search, color: Color(0xFF2c304d),),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: Color(0xAA2c304d), fontWeight: FontWeight.bold)
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Color(0xFFffffff),
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 3.0))]
        ),
      );
  }

  Widget listOpenGames(){
    return Container(
      child: RefreshIndicator(
        child: games.isEmpty ? Text("There is currently no live games") :
        ListView.builder(
          itemCount: games.length,
          itemBuilder: (BuildContext context, int index) {
            return filter == null || filter == "" ? 
            buildGameTile(context, index) : games[index].creatorName.contains(filter) ? 
            buildGameTile(context, index) : new Container();
          },
        ),
        onRefresh: _refreshOpenGames,
      )
    );
  }

  Widget buildGameTile(BuildContext context, int index) {
    return Card(
      child: InkWell(
        onTap: () => joinGame(index),
        child: Container(
          margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              scoreCard("Category", games[index].category, true),
              scoreCard("Creator", games[index].creatorName, true),
              scoreCard("Dificulty", games[index].difficulty[0].toUpperCase() + games[index].difficulty.substring(1), true),
              Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: joinCard((games[index].password != null)),
              ),
            ],
          )
        ),
      ),
    );
  }

   joinGame(int index){
    if(games[index].password != null){
      print("Game ${games[index].creatorName} has password");
      passwordAlertDialog(index);
    }else {
      
      Database().joinGame(games[index])
        .then((onValue) => onValue ? 
          Navigator.pushNamed(context, '/multiplayerGame?gameID=${games[index].gameID}&owner=false') : toast("The game is no longer avaliable"));
    }

  }

  passwordAlertDialog(int index){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
      title: Text('Password:'),
      content: TextField(
        keyboardType: TextInputType.number,
        controller: passwordFieldControler,
        
        decoration: InputDecoration(hintText: "Enter password here"),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Join game'),
          onPressed: () {

            if(passwordFieldControler.text == games[index].password){
              passwordFieldControler.text = '';
              Navigator.of(context).pop();
              doSomething(index);
            }else {
              toast("Incorrect Password");
            }

          },
        )
      ],
    );
    });
  }

  doSomething(int index){
    Database().joinGame(games[index])
                .then((onValue) => onValue ? 
                  Navigator.pushNamed(context, '/multiplayerGame?gameID=${games[index].gameID}&owner=false') : toast("The game is no longer avaliable"));
  }

  toast(String string){
    Fluttertoast.showToast(
        msg: string,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.white70,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }



  Widget joinCard(bool isPasswordLocked){
    return Column(
      children: <Widget>[
         Container(
          child: Center(
            child: Text(
              "Join",
              style: TextStyle(
                color: const Color(0xFFca4451),
                fontWeight: FontWeight.bold
              ),
            )
          ),
        ),
        isPasswordLocked ? 
          Container(
            child: Icon(Icons.lock),
          )
        : Container()
      ],
    );
  }


  Widget scoreCard(String title, String score, bool divider) {
    return Expanded(
      child: Container(
        decoration: divider
            ? BoxDecoration(
                border: BorderDirectional( 
                  end: BorderSide(color: const Color(0x222c304d))
                )
              )
            : null,
        child: Column(
          children: <Widget>[
            Container(
              child: Center(
                  child: Text(
                title,
                style: TextStyle(
                    color: Colors.grey,
                    ),
              )),
            ),
            Container(
              child: Center(
                  child: Text(
                score.toString(),
                style: TextStyle(
                  color: const Color(0xFF2c304d),
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshOpenGames() async{
    games = [];
    fetchOpenGames();
  }


  fetchOpenGames() async{
    
    games = await Database().getLiveGames();
    liveGames = games.length;
  
    setState(() {
      doneLoading = true;  
    });
  }
}