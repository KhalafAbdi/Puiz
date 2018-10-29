import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 200.0,
      width: 200.0,
      child: Center(
        child: Text("data"),
      ),
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