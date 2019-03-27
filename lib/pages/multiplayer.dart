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



  bool doneLoading = false;
  User user;

  int liveGames = 0;

  List<Game> games = [];

  
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCategory;

  @override
    void initState() {
      super.initState();

      _dropDownMenuItems = getDropDownMenuItems();
      _currentCategory = _dropDownMenuItems[0].value;

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
              child:  Icon(Icons.add),
              onPressed: _showDialog
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



  _showDialog() async {
    await showDialog(
             context: context,
                builder: (BuildContext context) {
                   return new SimpleDialog(
                      title: new Text('Create New Game'),
                      children: <Widget>[
                         new SimpleDialogOption(
                            onPressed: () {
                             print("test");
                            },
                      child: new Center(
                        child: new DropdownButton<String>(
                            hint: new Text("Select Category"),
                            value: getCat(),
                            items: _categories.map((String val) {
                              return new DropdownMenuItem<String>(
                                value: val,
                                child: new Text(val),
                              );
                            }).toList(),
                            onChanged: changedDropDownItem,)
                      ),
                    ),
                  ],
                );
              });
  }

  String getCat(){
    return _currentCategory;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String category in _categories) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: category,
          child: new Text(category)
      ));
    }
    return items;
  }

    void changedDropDownItem(String selectedCategory) {
    print("Selected city $selectedCategory, we are going to refresh the UI");
    setState(() {
      _currentCategory = selectedCategory;
    });
  }


/*

new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Full Name', hintText: 'eg. John Smith'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () => print('cancel')),
          new FlatButton(
              child: const Text('OPEN'),
              onPressed: () => print('open')),
        ],
*/


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






/*
Column(
          children: <Widget>[
            Text(games[index].category),
            Text(games[index].creatorName, style: TextStyle(color: Colors.deepPurple))
          ],
        ),
*/

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