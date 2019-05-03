import 'package:flutter/material.dart';

final pages = [
  PageViewModel(
      const Color(0xFFca4451),
      'assets/quiz.png',
      'Quiz',
      'Pick a category and go on a quiz adventure. Get points for each right answer',
      'assets/quiz.png',
      false),

  PageViewModel(
      const Color(0xFF2c304d),
      'assets/deathmatch.png',
      'DeathMatch',
      'See how many questions in a row you can get correct! win big prices!',
      'assets/deathmatch.png',
      false),

  PageViewModel(
    const Color(0xFF548CFF),
    'assets/multiplayer.png',
    'MultiPlayer!',
    'Play against your friends and see who can score the most points!',
    'assets/multiplayer.png',
    true,
  ),
];

class Page extends StatelessWidget {
  final PageViewModel viewModel;
  final double percentVisible;


  Page({
    this.viewModel,
    this.percentVisible = 1.0,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: viewModel.color,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft, 
              margin: EdgeInsets.only(top:40.0),
              child: FlatButton(
                onPressed: () => Navigator.of(context).pushNamed("/"),
                child:Text("Skip",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white70,
                      fontWeight: FontWeight.w300)),
              )
            ),
            Expanded(
                          child: Container(
                alignment: Alignment.center,
                            child: Opacity(
                  opacity: percentVisible,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform(
                          transform: Matrix4.translationValues(
                              0.0, 50.0 * (1.0 - percentVisible), 0.0),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: Image.asset(viewModel.heroAssetPath,
                                width: 200.0, height: 200.0),
                          ),
                        ),
                        Transform(
                          transform: Matrix4.translationValues(
                              0.0, 30.0 * (1.0 - percentVisible), 0.0),
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              viewModel.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'FlamanteRoma',
                                fontSize: 34.0,
                              ),
                            ),
                          ),
                        ),
                        Transform(
                          transform: Matrix4.translationValues(
                              0.0, 30.0 * (1.0 - percentVisible), 0.0),
                          child: Padding(
                              padding: EdgeInsets.only(bottom: 75.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    viewModel.body,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'FlamanteRomaItalic',
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        (viewModel.finalPage) ? Container(
                          child: Row(
                            children: <Widget>[
                              themeButton(context, "Get Started!", 20.0, const Color(0xFFca4451)),
                            ],
                          ) 
                        ) : Container()
                      ]),
                ),
              ),
            )
          ],
        ));
  }

  Widget themeButton(context, title, size, color,) {
    return Expanded(
          child: Container(
        margin: EdgeInsets.all(15.0),
        color: color,
        child: MaterialButton(
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Roboto', fontSize: size),
            ),
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            }),
      ),
    );
  }
}

class PageViewModel {
  final Color color;
  final String heroAssetPath;
  final String title;
  final String body;
  final String iconAssetPath;
  final bool finalPage;

  PageViewModel(
    this.color,
    this.heroAssetPath,
    this.title,
    this.body,
    this.iconAssetPath,
    this.finalPage
  );
}
