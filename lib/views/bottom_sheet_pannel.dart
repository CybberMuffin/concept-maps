import 'package:concept_maps/views/bottom_sheet_graph.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:concept_maps/views/bottom_pannel.dart';
import "package:swipedetector/swipedetector.dart";
import 'package:concept_maps/models/graph_entities/node.dart';

class BottomSheetPannel extends StatefulWidget {

  @override
  _BottomSheetPannelState createState() => _BottomSheetPannelState();
}

class _BottomSheetPannelState extends State<BottomSheetPannel> with SingleTickerProviderStateMixin {

  Widget panel;
  bool isPannelAdded;
  bool isPannelAddedUpper;
  bool showGraph;
  AnimationController controller;
  Animation curve;
  Animation<double> panelAnimation;
  Animation<double> panelAnimation2;
  Animation<double> panelAnimation3;
  Animation<double> panelAnimation4;
  double height;

  dragPanelUp(){
    final size = MediaQuery.of(context).size;
    if (isPannelAdded == false){
      setState(() {
        height = size.height*0.4;
        isPannelAdded = true;
        panel = BottomPannel();
      });
    } else if (isPannelAdded == true && isPannelAddedUpper == false){
      setState(() {
        height = size.height;
        isPannelAddedUpper = true;
        panel = BottomPannel();
      });
    }
  }

  dragPanelDown() {
    final size = MediaQuery.of(context).size;
    if (isPannelAdded == true && isPannelAddedUpper == false) {
      setState(() {
        height = 40;
        isPannelAdded = false;
        panel = Container();

      });
    } else if (isPannelAdded == true && isPannelAddedUpper == true) {
      setState(() {
        height = size.height*0.4;
        isPannelAddedUpper = false;
        panel = Container();
      });
    }
  }



  @override
  void initState(){
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    panelAnimation = Tween<double>(begin: 40, end: 370).animate(curve)
      ..addListener(() {
        setState(() {// The state that has changed here is the animation object’s value.
        });
      });
    panelAnimation2 = Tween<double>(begin: 370, end: 660).animate(curve)
      ..addListener(() {
        setState(() {// The state that has changed here is the animation object’s value.
        });
      });
    panelAnimation3 = Tween<double>(begin: 660, end: 370).animate(curve)
      ..addListener(() {
        setState(() {// The state that has changed here is the animation object’s value.
        });
      });
    panelAnimation4 = Tween<double>(begin: 370, end: 40).animate(curve)
      ..addListener(() {
        setState(() {// The state that has changed here is the animation object’s value.
        });
      });
    controller.forward();
    isPannelAdded = false;
    isPannelAddedUpper = false;
    height = 40;
    panel = Container();
    showGraph = false;
  }

  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              //offset: Offset(0, 3),
            )
          ]
      ),
      //margin: const EdgeInsets.only(top: 35.0, bottom: 15, right: 15, left: 15),
      padding: const EdgeInsets.only(bottom: 5.0, left: 15, right: 15),
      child: Container(

        child: Column(
          children: [
            SwipeDetector(
              onSwipeUp: (){
                dragPanelUp();
              },
              onSwipeDown: (){
                dragPanelDown();
              },
              child: Container(
                child: Container(
                  margin: EdgeInsets.only(top: 15, bottom: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Icon(Icons.brightness_1_rounded, size: 6, color: (showGraph == false) ? Colors.black : Colors.blueGrey[600],),
                        margin: const EdgeInsets.only(left: 2.0),
                      ),
                      Container(
                        child: Icon(Icons.brightness_1_rounded, size: 6, color: (showGraph == true) ? Colors.black : Colors.blueGrey[600],),
                        margin: const EdgeInsets.only(left: 2.0),
                      ),
                      Container(
                        child: Icon(Icons.brightness_1_rounded, size: 6, color: Colors.blueGrey[700]),
                        margin: const EdgeInsets.only(left: 2.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: height - 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SwipeDetector(
                  onSwipeLeft: (){
                    setState(() {
                      showGraph = true;
                    });
                    print(showGraph);
                  },
                  onSwipeRight: (){
                    setState(() {
                      showGraph = false;
                    });
                    print(showGraph);
                  },
                  child: Container(
                    //color: Colors.red,
                      child: (showGraph == false) ? BottomPannel() : BottomSheetGraph()
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

}