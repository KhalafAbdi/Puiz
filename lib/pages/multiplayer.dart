import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pro/model/user.dart';
import 'package:pro/model/game.dart';

class MultiplayerPage extends StatefulWidget {
  int index;

  MultiplayerPage(this.index);

  @override
  _MultiplayerPageState createState() => _MultiplayerPageState();
}

class _MultiplayerPageState extends State<MultiplayerPage> {




  bool doneLoading = false;
  User user;

  int liveGames = 0;

  List<Game> games = [];

  @override
    void initState() {
      super.initState();


      fetchOpenGames();
    }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("M U L T I P L A Y E R",
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.w300)),
        backgroundColor: const Color(0xFF2c304d),
      ),
      body: buildBody(context),
    ));
  }

  buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, const Color(0xFFca4451)],
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(0.3, 0.15),
              stops: [1.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                /*Center(
                  child: Text("Find Game",
                        style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300)),
                  ),*/
                  CustomSearchBox(),
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

  Widget CustomSearchBox(){
    return Container(
        margin: EdgeInsets.only(top:15.0, bottom: 30.0),
        height: 57.0,
        width: MediaQuery.of(context).size.width/1.2,
        child: Padding(
          padding: EdgeInsets.only(left:30.0,top:5.0),
          child: TextField(
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
    if (games.isEmpty){
      return Text("There is currently no live games");
    }

    return Container(
      child: RefreshIndicator(
        child: ListView.builder(
          itemBuilder: buildGameTile,
          itemCount: games.length
        ),
        onRefresh: _refreshOpenGames,
      )

    );

  }

  Widget buildGameTile(BuildContext context, int index) {
    return Card(
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
              child: joinCard(games[index].hasPassword),
            ),
          ],
        )
      ),
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


  Future<void> fetchOpenGames() async{
    var respectsQuery = Firestore.instance.collection('Games').where('state', isEqualTo: 'open');
    var querySnapshot = await respectsQuery.getDocuments();
    List<DocumentSnapshot> d = querySnapshot.documents;

    liveGames = querySnapshot.documents.length;

    bool hasPassword = false;


    for(DocumentSnapshot snapshot in d){
      if(snapshot.data['password'] != ""){
        hasPassword = true;
      }

      games.add(
        Game(
          snapshot.documentID,
          snapshot.data['category'],
          snapshot.data['difficulty'],
          snapshot.data['creatorID'],
          snapshot.data['creatorName'],
          snapshot.data['state'],
          hasPassword,
          )
      );
    }

    setState(() {
      doneLoading = true;
    });
  }





}