import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/database.dart';
import 'package:pro/pages/navigation_controller.dart';

class QuizzesPage extends StatefulWidget {
  @override
  _QuizzesPageState createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  Widget _currentPage;
  String title;
  bool goback = false;

  @override
  initState() {
    _currentPage = listCategories();
    title = "Category List";
  }

  updatePage(Widget widget){
    setState(() {
          _currentPage = widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        automaticallyImplyLeading: false,
        leading: goback ? IconButton(
            tooltip: 'Previous choice',
            icon: const Icon(Icons.arrow_back),
            onPressed: () => updatePage(listCategories()),) : null
      ),
      body: _currentPage,
    );
  }

  Widget listCategories(){
    return new FutureBuilder<List<DocumentSnapshot>>(
        future: Database().getQuizCategories(),
        builder: (BuildContext context,
            AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => _eachList(
                    index,
                    snapshot.data[index].documentID,
                    snapshot.data[index]['desc']));
          } else {
            return new Text('Loading...');
          }
        });
  }

  _eachList(int index, String title, subtitle){
    return ListTile(
        leading: CircleAvatar(child: Text(title[0])),
        title: Text(title),
        subtitle: Text(subtitle),
        enabled: true,
        onTap: () => updatePage(listSubCategories(title)));
  }

  Widget listSubCategories(String title){
    this.title = title;
    goback = true;

    return WillPopScope(
          onWillPop: _onWillPop,
          child: FutureBuilder<List<DocumentSnapshot>>(
          future: Database().getQuizCategory(title),
          builder: (BuildContext context,
              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => _subItems(
                      index,
                      snapshot.data[index].documentID,
                      snapshot.data[index]['desc']));
            } else {
              return new Text('Loading...');
            }
          }),
    );
  }

  Future<bool> _onWillPop(){
    updatePage(listCategories());
  }

  _subItems(int index, String title, subtitle){

    return ListTile(
        leading: CircleAvatar(child: Text(title[0])),
        title: Text(title),
        subtitle: Text(subtitle),
        enabled: true,
        onTap: () => {});
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
