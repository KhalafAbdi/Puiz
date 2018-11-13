import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/database.dart';
import 'package:pro/config/application.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizzesPage extends StatefulWidget {
  final int index;
  final String title;

  QuizzesPage(this.index, [this.title]);

  @override
  _QuizzesPageState createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  bool canGoBack = false;
  Widget _currentPage;
  String title;
  
  @override
  initState() {
    if (widget.title == null || widget.title == "quiz") {
      _currentPage = listCategories();
      title = "Q U I Z";
    } else {
      _currentPage = listSubCategories(widget.title);
      title = styleText(widget.title);
    }

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
                leading: canGoBack
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
        Container(
          child: SingleChildScrollView(
            child: _currentPage
          ),
        ),
      ],
    );
  }

  Widget listCategories() {
    title = "Q U I Z";
    canGoBack = false;

    return FutureBuilder<List<DocumentSnapshot>>(
        future: Database().getQuizCategories(),
        builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          return snapShotRes(snapshot, categoryList);
        });
  }

  Widget listSubCategories(String title) {
    this.title = styleText(title);
    canGoBack = true;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: FutureBuilder<List<DocumentSnapshot>>(
          future: Database().getQuizCategory(title),
          builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            return snapShotRes(snapshot, cardTiles, title);
          }),
    );
  }

  Widget snapShotRes(AsyncSnapshot<List<DocumentSnapshot>> snapshot, Function func, [String name]){
    if (snapshot.hasError) print(snapshot.error);

    return snapshot.hasData
      ? (name == null) ? func(snapshot.data) : func(snapshot.data, name)
      : Container(
        height: MediaQuery.of(context).size.height-60.0,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,   
          child: new CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
              const Color(0xFFca4451))),
      );
  }

  Widget categoryList(List<DocumentSnapshot> data) {
    Map<String, Widget> map = new Map.fromIterable(data,
        key: (item) => item.documentID,
        value: (item) => categoryCards(item.documentID, listSubCategories, updatePage));

    List<Widget> list = [];
    map.forEach((s, w) => (s == "Newest Category") ? null : list.add(w));

    return gridWidget(list);
  }

    Widget cardTiles(List<DocumentSnapshot> data, String name) {
    openQuiz(data.length, name);

    List<Widget> list = List.generate(data.length, (index) {
      return categoryCards(data[index].documentID, openQuiz);
    });

    return gridWidget(list);
  }

  Widget categoryCards(String name, Function func, [Function func2]) {
    return card(name, 'assets/${name.replaceAll(" ", "")}.png', func, func2);
  }

  Widget gridWidget(List<Widget> list) {
    return GridView.count(
        primary: false,
        crossAxisCount: 3,
        shrinkWrap: true,
        childAspectRatio: 0.65,
        mainAxisSpacing: 7.0,
        crossAxisSpacing: 7.0,
        children: list);
  }

  Widget card(String name, String iconPath, Function func, [Function func2]){
    return Card(
      margin: EdgeInsets.all(5.0),
      color: Colors.white,
      child: InkWell(
        onTap: () => (func2 == null) ? func(0, name) : func2(func(name)), // Quiz(int, string) : updatePage(listSubCategories(string))
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                child: Image.asset(iconPath)),
            Text(name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15.0,
                    color: const Color(0xFF2c304d),
                    fontWeight: FontWeight.w600))
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


  Future<bool> _onWillPop() {
    updatePage(listCategories());
  }

  openQuiz(int i, String title) async {
    title = title.replaceAll("&", "and"); // fluro can't handle &
    FirebaseUser _auth = await FirebaseAuth.instance.currentUser(); //hack

    if (i <= 0) {
      Application.router
          .navigateTo(context, "/quiz?subject=$title", clearStack: true);
    }
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

