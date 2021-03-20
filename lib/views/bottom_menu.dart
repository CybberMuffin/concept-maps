import 'package:flutter/material.dart';
import 'package:concept_maps/views/bottom_pannel.dart';
import 'package:swipedetector/swipedetector.dart';

class BottomMenu extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu>
    with SingleTickerProviderStateMixin {
  List<BottomPannel> panel;
  bool isPannelAdded;
  bool isPannelAddedUpper;
  AnimationController controller;
  Animation curve;
  Animation<double> panelAnimation;
  Animation<double> panelAnimation2;
  Animation<double> panelAnimation3;
  Animation<double> panelAnimation4;
  double height;

  dragPanelUp() {
    if (isPannelAdded == false) {
      setState(() {
        height = panelAnimation.value;
        isPannelAdded = true;
        panel.add(BottomPannel());
      });
    } else if (isPannelAdded == true && isPannelAddedUpper == false) {
      setState(() {
        height = panelAnimation2.value;
        isPannelAddedUpper = true;
        panel.add(BottomPannel());
      });
    }
  }

  dragPanelDown() {
    if (isPannelAdded == true && isPannelAddedUpper == false) {
      setState(() {
        height = 40;
        isPannelAdded = false;
        panel.removeLast();
      });
    } else if (isPannelAdded == true && isPannelAddedUpper == true) {
      setState(() {
        height = 370;
        isPannelAddedUpper = false;
        panel.removeLast();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    panelAnimation = Tween<double>(begin: 40, end: 370).animate(curve)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    panelAnimation2 = Tween<double>(begin: 370, end: 660).animate(curve)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    panelAnimation3 = Tween<double>(begin: 660, end: 370).animate(curve)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    panelAnimation4 = Tween<double>(begin: 370, end: 40).animate(curve)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    controller.forward();
    panel = <BottomPannel>[];
    isPannelAdded = false;
    isPannelAddedUpper = false;
    height = 40;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        height: height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(25.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                //offset: Offset(0, 3),
              )
            ]),
        //margin: const EdgeInsets.only(top: 35.0, bottom: 15, right: 15, left: 15),
        padding: const EdgeInsets.only(bottom: 15.0, left: 15, right: 15),
        child: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                children: [
                  SwipeDetector(
                    onSwipeUp: () {
                      dragPanelUp();
                    },
                    onSwipeDown: () {
                      dragPanelDown();
                    },
                    child: Container(
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(
                                Icons.brightness_1_rounded,
                                size: 6,
                                color: Colors.blueGrey[700],
                              ),
                              margin: const EdgeInsets.only(left: 2.0),
                            ),
                            Container(
                              child: Icon(Icons.brightness_1_rounded,
                                  size: 6, color: Colors.blueGrey[700]),
                              margin: const EdgeInsets.only(left: 2.0),
                            ),
                            Container(
                              child: Icon(Icons.brightness_1_rounded,
                                  size: 6, color: Colors.blueGrey[700]),
                              margin: const EdgeInsets.only(left: 2.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: panel.map((BottomPannel panel) {
                      return panel;
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 900,
          color: Colors.red,
        ),
      ),
    );
  }
}
