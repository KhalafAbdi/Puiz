import 'package:flutter/material.dart';
import '../../data/database.dart';
import 'package:pro/config/application.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pro/widgets/custom_widgets.dart' as customWidget;
import 'package:pro/data/constants.dart' as constants;

class QuizPage extends StatefulWidget {
  final int index;
  final String title;

  QuizPage(this.index, [this.title]);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
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
        customWidget.backgroundWidget(Colors.white, const Color(0xFFca4451)),
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

    return FutureBuilder(
        future: Database().getQuizCategories(),
        builder: (BuildContext context,  snapshot) {
          return snapShotRes(snapshot, categoryList);
        });
  }

  Widget listSubCategories(String title) {
    this.title = styleText(title);
    canGoBack = true;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: FutureBuilder(
          future: Database().getQuizCategory(title),
          builder: (context, snapshot) {
            return snapShotRes(snapshot, cardTiles, title);
          }),
    );
  }

  Widget snapShotRes(snapshot, Function func, [String name]){
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

  Widget categoryList(data) {
    Map<String, Widget> map = new Map.fromIterable(data,
        key: (item) => item.documentID,
        value: (item) => categoryCards(item.documentID, listSubCategories, updatePage));

    List<Widget> list = [];
    map.forEach((s, w) => (s == constants.newestCategoryCollection) ? null : list.add(w));

    return gridWidget(list);
  }

    Widget cardTiles(data, String name) {
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

