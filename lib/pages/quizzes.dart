import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoadingPage.dart';
import '../data/database.dart';

class QuizzesPage extends StatefulWidget {
  @override
  _QuizzesPageState createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {


@override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<DocumentSnapshot>>(
            future: Database().getQuizCategories(),
            builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) => EachList(index, snapshot.data[index].documentID, snapshot.data[index]['desc'])
                  );

                } else {
                   return new Text('Loading...');
                }
              }
          );
  }
}

class EachList extends StatelessWidget {
  int index;
  String title;
  String subtitle;

  EachList(this.index, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child:Text(title[0]) ),
      title: Text(title),
      subtitle: Text(subtitle),
      enabled: true,
      onTap: () { /* react to the tile being tapped */ }
    );
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




*/