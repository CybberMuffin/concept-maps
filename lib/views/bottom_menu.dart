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
  AnimationController controller;
  Animation curve;
  Animation<double> panelAnimation;

  callPanel() {
    if (isPannelAdded == false) {
      setState(() {
        isPannelAdded = true;
        panel.add(BottomPannel());
      });
    } else if (isPannelAdded == true) {
      setState(() {
        isPannelAdded = false;
        panel.removeLast();
      });
    }
  }

  dragPanelUp() {
    if (isPannelAdded == false) {
      setState(() {
        isPannelAdded = true;
        panel.add(BottomPannel());
      });
    }
  }

  dragPanelDown() {
    if (isPannelAdded == true) {
      setState(() {
        isPannelAdded = false;
        panel.removeLast();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    panelAnimation = Tween<double>(begin: 650, end: 320).animate(curve)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    controller.forward();
    panel = <BottomPannel>[];
    isPannelAdded = false;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SwipeDetector(
        onSwipeUp: () {
          dragPanelUp();
        },
        onSwipeDown: () {
          dragPanelDown();
        },
        child: Container(
          //margin: EdgeInsets.only(top:320),
          child: Column(
            children: [
              Container(
                margin: (isPannelAdded == false)
                    ? EdgeInsets.only(top: 650)
                    : EdgeInsets.only(top: panelAnimation.value),
              ),
              Container(
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
                padding:
                    const EdgeInsets.only(bottom: 15.0, left: 15, right: 15),
                child: Column(
                  children: [
                    Container(
                      child: InkWell(
                        onTap: () {} /*callPanel*/,
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
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
                    //BottomPannel(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
