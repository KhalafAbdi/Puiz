import "package:flutter/material.dart";
import 'dart:math';

class LoadingPage extends StatefulWidget {
  final double radius;
  final double dotRadius;

  LoadingPage({this.radius = 10.0, this.dotRadius = 7.0});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation_rotation;
  Animation<double> animation_radius_in;
  Animation<double> animation_radius_out;
  AnimationController controller;

  double radius;
  double dotRadius;
  String loadingText = "L o a d i n g";
  bool addDotFlip = false;

  @override
  void initState() {
    super.initState();

    radius = widget.radius;
    dotRadius = widget.dotRadius;

    print(dotRadius);

    controller = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 3000),
        vsync: this);

    animation_rotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    animation_radius_in = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn),
      ),
    );

    animation_radius_out = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );

    controller.addListener(() {
      setState(() {

        if(controller.value >= 0.0 && controller.value <= 0.25){
          !addDotFlip ? _updateLoading(false) : null;
          radius = widget.radius * animation_radius_out.value; 
        }else if (controller.value >= 0.25 && controller.value <= 0.5){
          addDotFlip ? _updateLoading(false) : null;
        }else if (controller.value >= 0.5 && controller.value <= 0.75){
          !addDotFlip ? _updateLoading(false) : null;
        }else if (controller.value >= 0.75 && controller.value <= 1.0){
          addDotFlip ? _updateLoading(true) : null;
          radius = widget.radius * animation_radius_in.value;
        }

      });
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });

    controller.repeat();
  }

  _updateLoading(bool last){
    loadingText = last ? "L o a d i n g" : loadingText + " .";
    addDotFlip = !addDotFlip;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFFfe7f3b), const Color(0xFFfe2851)],
              begin: FractionalOffset(0.0, 1.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
            width: 200.0,
            height: 200.0,
            child: new Center(
              child: new RotationTransition(
                turns: animation_rotation,
                child: new Container(
                  child: new Center(
                    child: Stack(
                      children: <Widget>[
                        new Transform.translate(
                          offset: Offset(0.0, 0.0),
                          child: Dot(
                            radius: radius,
                            color: Colors.white,
                          ),
                        ),
                        new Transform.translate(
                          child: Dot(
                            radius: dotRadius,
                            color: Colors.white,
                          ),
                          offset: Offset(
                            (radius + 50) * cos(0.0),
                            (radius + 50) * sin(0.0),
                          ),
                        ),
                        new Transform.translate(
                          child: Dot(
                            radius: dotRadius,
                            color: Colors.white,
                          ),
                          offset: Offset(
                            (radius + 50) * cos(0.0 + 1 * pi / 4),
                            (radius + 50) * sin(0.0 + 1 * pi / 4),
                          ),
                        ),
                        new Transform.translate(
                          child: Dot(
                            radius: dotRadius,
                            color: Colors.white,
                          ),
                          offset: Offset(
                            (radius + 50) * cos(0.0 + 2 * pi / 4),
                            (radius + 50) * sin(0.0 + 2 * pi / 4),
                          ),
                        ),
                        new Transform.translate(
                          child: Dot(
                            radius: dotRadius,
                            color: Colors.white,
                          ),
                          offset: Offset(
                            (radius + 50) * cos(0.0 + 3 * pi / 4),
                            (radius + 50) * sin(0.0 + 3 * pi / 4),
                          ),
                        ),
                        new Transform.translate(
                          child: Dot(
                            radius: dotRadius,
                            color: Colors.white,
                          ),
                          offset: Offset(
                            (radius + 50) * cos(0.0 + 4 * pi / 4),
                            (radius + 50) * sin(0.0 + 4 * pi / 4),
                          ),
                        ),
                        new Transform.translate(
                          child: Dot(
                            radius: dotRadius,
                            color: Colors.white,
                          ),
                          offset: Offset(
                            (radius + 50) * cos(0.0 + 5 * pi / 4),
                            (radius + 50) * sin(0.0 + 5 * pi / 4),
                          ),
                        ),
                        new Transform.translate(
                          child: Dot(
                            radius: dotRadius,
                            color: Colors.white,
                          ),
                          offset: Offset(
                            (radius + 50) * cos(0.0 + 6 * pi / 4),
                            (radius + 50) * sin(0.0 + 6 * pi / 4),
                          ),
                        ),
                        new Transform.translate(
                          child: Dot(
                            radius: dotRadius,
                            color: Colors.white,
                          ),
                          offset: Offset(
                            (radius + 50) * cos(0.0 + 7 * pi / 4),
                            (radius + 50) * sin(0.0 + 7 * pi / 4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ),
        Text(loadingText, style: TextStyle(color: Colors.white, fontSize: 20.0))
            ]
          ),
      ),
    );
  }

  @override
  void dispose() {

    controller.dispose();
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle),
      ),
    );
  }
}