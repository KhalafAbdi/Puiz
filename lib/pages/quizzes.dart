import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/database.dart';

class QuizzesPage extends StatefulWidget {
  @override
  _QuizzesPageState createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  Widget _currentPage;
  String title;
  bool goback = false;
  List colors = [
    Colors.indigo,
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.pink
  ];

  @override
  initState() {
    _currentPage = listCategories();
    title = "Q U I Z";
    super.initState();
  }

  updatePage(Widget widget) {
    setState(() {
      _currentPage = widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: Text(title,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w300)),
                backgroundColor: const Color(0xFF2c304d),
                leading: goback
                    ? IconButton(
                        tooltip: 'Previous choice',
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => updatePage(listCategories()))
                    : null),
            body: buildBody(context)));
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
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_currentPage],
            ),
          ),
        )
      ],
    );
  }

  Widget listCategories() {
    title = "Q U I Z";
    goback = false;

    return FutureBuilder<List<DocumentSnapshot>>(
        future: Database().getQuizCategories(),
        builder: (BuildContext context,
            AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => categoryButton(
                    index,
                    Icons.assistant,
                    snapshot.data[index].documentID,
                    snapshot.data[index]['desc']));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget categoryButton(index, icon, title, subText) {
    return InkWell(
      onTap: () => updatePage(listSubCategories(title)),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        color: colors[index],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 15.0, left: 15.0, bottom: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: BorderDirectional(
                          end: BorderSide(color: Colors.white))),
                  padding: EdgeInsets.only(right: 15.0),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 40.0,
                  ),
                )),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10.0, left: 15.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.0, bottom: 5.0),
                  child: Text(
                    subText,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                      color: const Color(0xFFeaeaea),
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  String styleText(String title) {
    String upperCasetitle = title.toUpperCase();
    String result = "";

    for (int i = 0; i < upperCasetitle.length; i++) {
      result = result + upperCasetitle[i] + " ";
    }
    return result;
  }

  Widget listSubCategories(String title) {
    this.title = styleText(title);
    goback = true;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: FutureBuilder<List<DocumentSnapshot>>(
          future: Database().getQuizCategory(title),
          builder: (BuildContext context,
              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? cardTiles(snapshot.data)
                : new Center(child: new CircularProgressIndicator());
          }),
    );
  }

  Widget cardTiles(List<DocumentSnapshot> data) {
    return GridView.count(
      primary: false,
      crossAxisCount: 3,
      shrinkWrap: true,
      childAspectRatio: 0.80,
      mainAxisSpacing: 7.0,
      crossAxisSpacing: 7.0,
      children: List.generate(data.length, (index) {
        return loadCard(data[index].documentID, index);
      }),
    );
  }

  Widget loadCard(title, index) {
    List icons = [Icons.palette, Icons.near_me, Icons.nature, Icons.movie];

    return InkWell (
      onTap: () => print("You tapped on $title"),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: const Color(0xAA2c304d), width: 2.0),
              right: BorderSide(color: const Color(0xAA2c304d), width: 2.0),
            )),
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icons[index],
                  color: const Color(0xFFca4451),
                  size: 100.0,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 5.0),
                  child: Text(title,
                      style: TextStyle(
                          fontSize: 15.0,
                          color: const Color(0xFF2c304d),
                          fontWeight: FontWeight.w300)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    updatePage(listCategories());
  }
}

/*

Users
  > userid
    - displayName 
    - email

Categories
  > TV
    - categoryID // Friends
    - categoryID // Game of thrones abstract
    - categoryID // Dragon ball Z

  > Movies
    - categoryID // Harry potter
    - categoryID // Disney movies
    - categoryID // Starwars

Category
  > categoryID
    - title
    - sub text
    - Icon

  > categoryID
    - title
    - sub text
    - Icon

Question
  > categoryID
    > Easy
      > questionID
        - question
        - answer 1
        - answer 2
        - answer 3
        - answer 4

      > questionID
        - question
        - answer 1
        - answer 2
        - answer 3
        - answer 4

    > Medium
      > questionID
        - question
        - answer 1
        - answer 2
        - answer 3
        - answer 4

Answers
  > questionID
    - correctAnswer

  > questionID
    - correctAnswer

  > questionID
    - correctAnswer

Rankings
  > City
    > categoryID
      > 1
        - userid
        - score

      > 2
        - userid
        - score

  > Country

  > Global

Following


Categories
  > Enteraintment
    - desc: String
    - subCategories: String ("Music, Games, TV, Movies")
    > Music
      - desc: String
      - subCategories: String
    > Games
      - desc: String
      - subCategories: String
    > TV
      - desc: String
      - subCategories: String
    > Movies 
      - desc: String
      - subCategories: String

  > Geography
  .
  .
  .

Category
  > Music
  > Games
  > TV
  > Movies


*/
