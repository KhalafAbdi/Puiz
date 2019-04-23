import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pro/pages/onBoarding/animation/page_dragger.dart';
import 'package:pro/pages/onBoarding/animation/page_reveal.dart';
import 'package:pro/pages/onBoarding/ui/pager_indicator.dart';
import 'package:pro/pages/onBoarding/ui/pages.dart';

class OnBoadingControllerPage extends StatefulWidget {

  @override
  _OnBoadingControllerPageState createState() => _OnBoadingControllerPageState();
}


class _OnBoadingControllerPageState extends State<OnBoadingControllerPage> with TickerProviderStateMixin {

   StreamController<SlideUpdate> slideUpdateStream;
   AnimatedPageDragger animatedPageDragger;

   int activeIndex = 0 ;
   SlideDirection slideDirection = SlideDirection.none;
   int nextPageIndex = 0 ;
   double slidePercent= 0.0;

  _OnBoadingControllerPageState(){

    slideUpdateStream = StreamController<SlideUpdate>();
    slideUpdateStream.stream.listen((SlideUpdate event){
      setState(() {
        if( event.updateType == UpdateType.dragging){
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if( slideDirection == SlideDirection.leftToRight ){
              nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.rightToLeft){
              nextPageIndex = activeIndex + 1;
          } else{
              nextPageIndex = activeIndex;
          }
        } else if( event.updateType == UpdateType.doneDragging){
          if(slidePercent > 0.5){

            animatedPageDragger = AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );

          } else{
            animatedPageDragger = AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.close,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );

            nextPageIndex = activeIndex;
          }

          animatedPageDragger.run();
        }
        else if( event.updateType == UpdateType.animating){
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        }

        else if (event.updateType == UpdateType.doneAnimating){
          activeIndex = nextPageIndex;

          slideDirection = SlideDirection.none;
          slidePercent = 0.0;

          animatedPageDragger.dispose();
        }
      });
    });


}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Page(
            viewModel: pages[activeIndex],
            percentVisible: 1.0 ,
          ),
          PageReveal(
            revealPercent: slidePercent,
            child: Page(
              viewModel: pages[nextPageIndex],
              percentVisible: slidePercent ,
            ),
          ),
          PagerIndicator(
              viewModel: PagerIndicatorViewModel(
                  pages,
                  activeIndex,
                  slideDirection,
                  slidePercent,
              ),
          ),
          PageDragger(
            canDragLeftToRight: activeIndex > 0 ,
            canDragRightToLeft: activeIndex < pages.length - 1 ,
            slideUpdateStream: this.slideUpdateStream,
          ),
        ],
      ),
    );
  }
}