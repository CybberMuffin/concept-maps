import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/views/bottom_pannel.dart';
import 'package:concept_maps/views/bottom_sheet_graph.dart';
import 'package:concept_maps/views/bottom_sheet_related_concepts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:swipedetector/swipedetector.dart";

class BottomSheetPannel extends StatefulWidget {
  @override
  _BottomSheetPannelState createState() => _BottomSheetPannelState();
}

class _BottomSheetPannelState extends State<BottomSheetPannel>
    with SingleTickerProviderStateMixin {
  Widget panel;
  bool isPannelAdded;
  bool isPannelAddedUpper;
  bool showGraph;
  AnimationController controller;
  Animation curve;
  Animation<double> panelAnimation;
  Animation<double> panelAnimation2;
  double height;
  double stickersHeight;
  bool purpleSticker;
  bool greenSticker;
  bool yellowSticker;
  List<Widget> pages;
  int pageIndex;

  dragPanelUp() {
    final size = MediaQuery.of(context).size;
    if (height == 40) {
      setState(() {
        pageIndex = 0;
        runAnimation(size.height * 0.4);
      });
    } else if (height == size.height * 0.4 && purpleSticker != true) {
      setState(() {
        runAnimation(size.height - 115);
      });
    }
  }

  dragPanelDown() {
    final size = MediaQuery.of(context).size;
    if (height == size.height * 0.4) {
      setState(() {
        runAnimation(40);
        yellowSticker = false;
        greenSticker = false;
        purpleSticker = false;
      });
    } else if (height == size.height - 115 && yellowSticker != true) {
      setState(() {
        runAnimation(size.height * 0.4);
      });
    } else if (height == size.height - 115 && yellowSticker == true) {
      setState(() {
        runAnimation(40);
        yellowSticker = false;
        greenSticker = false;
        purpleSticker = false;
      });
    }
  }

  void runAnimation(double newHeight) {
    curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    panelAnimation = controller
        .drive(CurveTween(curve: Curves.easeInOut))
        .drive(Tween<double>(begin: height, end: newHeight));
    controller.forward(from: 0.0);
  }

  @override
  void initState() {
    super.initState();
    pageIndex = 0;
    height = 40;
    yellowSticker = false;
    purpleSticker = false;
    greenSticker = false;
    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this)
          ..addListener(() {
            setState(() {
              height = panelAnimation.value;
            });
          });
    isPannelAdded = false;
    isPannelAddedUpper = false;
    panel = Container();
    showGraph = false;
  }

  @override
  void didChangeDependencies() {
    pages = [BottomPannel(), BottomSheetGraph(), RelatedConcepts()];
    final size = MediaQuery.of(context).size;

    if (Provider.of<AppProvider>(context).bottomSheetFlag == true) {
      runAnimation(size.height * 0.4);

      if (purpleSticker == false && yellowSticker == false && pageIndex == 0) {
        greenSticker = true;
      }
      if (greenSticker == false && yellowSticker == false && pageIndex == 1) {
        purpleSticker = true;
      }

      if (greenSticker == false && purpleSticker == false && pageIndex == 2) {
        yellowSticker = true;
      }

      Provider.of<AppProvider>(context).bottomSheetFlag = false;
    } else {
      greenSticker = false;
      purpleSticker = false;
      yellowSticker = false;
      pageIndex = 0;

      runAnimation(40);
    }

    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: height + 30,
      child: Stack(children: [
        (purpleSticker == false)
            ? Positioned(
                left: 80,
                top: (purpleSticker == false) ? 15 : 0,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      purpleSticker = !purpleSticker;
                      if (height == size.height - 115) {
                        runAnimation(size.height * 0.4);
                      }
                      if (greenSticker == true) {
                        greenSticker = false;
                      } else if (yellowSticker == true) {
                        yellowSticker = false;
                      }
                      pageIndex = 1;
                      if (greenSticker == false &&
                          purpleSticker == false &&
                          yellowSticker == false) {
                        setState(() {
                          runAnimation(40);
                          pageIndex = 0;
                        });
                      }
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xFFAA46FF),
                    ),
                    child: Icon(
                      Icons.share,
                      size: 20,
                      color: Color(0xFFcc91ff),
                    ),
                  ),
                ),
              )
            : Container(),
        (greenSticker == false)
            ? Positioned(
                left: 40,
                top: (greenSticker == false) ? 15 : 0,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      greenSticker = !greenSticker;
                      if (purpleSticker == true) {
                        purpleSticker = false;
                      } else if (yellowSticker == true) {
                        yellowSticker = false;
                      }
                      pageIndex = 0;

                      if (greenSticker == false &&
                          purpleSticker == false &&
                          yellowSticker == false) {
                        setState(() {
                          runAnimation(40);
                          pageIndex = 0;
                        });
                      }
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xFF46FFAE),
                    ),
                    child: Icon(
                      Icons.my_library_books,
                      size: 20,
                      color: Color(0xFFc9ffe7),
                    ),
                  ),
                ),
              )
            : Container(),
        (yellowSticker == false)
            ? Positioned(
                left: 120,
                top: (yellowSticker == false) ? 15 : 0,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      yellowSticker = !yellowSticker;
                      if (height == size.height * 0.4) {
                        runAnimation(size.height - 115);
                      }
                      if (purpleSticker == true) {
                        purpleSticker = false;
                      } else if (greenSticker == true) {
                        greenSticker = false;
                      }
                      pageIndex = 2;

                      if (greenSticker == false &&
                          purpleSticker == false &&
                          yellowSticker == false) {
                        setState(() {
                          runAnimation(40);
                          pageIndex = 0;
                        });
                      }
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(0xFFffab51),
                    ),
                    child: Icon(
                      Icons.mediation,
                      size: 20,
                      color: Color(0xFFffcb94),
                    ),
                  ),
                ),
              )
            : Container(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    //offset: Offset(0, 3),
                  )
                ]),
            //margin: const EdgeInsets.only(top: 35.0, bottom: 15, right: 15, left: 15),
            //padding: const EdgeInsets.only(bottom: 5.0, left: 15, right: 15),
            child: Container(
                child: Column(
              children: [
                SwipeDetector(
                  onSwipeUp: () {
                    dragPanelUp();
                    if (greenSticker == false && purpleSticker == false) {
                      greenSticker = true;
                    }
                  },
                  onSwipeDown: () {
                    dragPanelDown();
                    if (height == MediaQuery.of(context).size.height * 0.4) {
                      if (greenSticker == true || purpleSticker == true) {
                        greenSticker = false;
                        purpleSticker = false;
                      }
                    }
                  },
                  child: Container(
                    child: InkWell(
                      child: Container(
                        margin: EdgeInsets.only(top: 15, bottom: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Icon(
                                Icons.brightness_1_rounded,
                                size: 6,
                                color:
                                    // (greenSticker == true)
                                    //     ? Colors.black
                                    //     :
                                    Colors.blueGrey[600],
                              ),
                              margin: const EdgeInsets.only(left: 2.0),
                            ),
                            Container(
                              child: Icon(
                                Icons.brightness_1_rounded,
                                size: 6,
                                color:
                                    // (purpleSticker == true)
                                    //     ? Colors.black
                                    //     :
                                    Colors.blueGrey[600],
                              ),
                              margin: const EdgeInsets.only(left: 2.0),
                            ),
                            Container(
                              child: Icon(
                                Icons.brightness_1_rounded,
                                size: 6,
                                color:
                                    // (purpleSticker == true)
                                    //     ? Colors.black
                                    //     :
                                    Colors.blueGrey[600],
                              ),
                              margin: const EdgeInsets.only(left: 2.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: height - 40,
                  child: Container(
                      //color: Colors.red,
                      child: pages[pageIndex]),
                )
              ],
            )),
          ),
        ),
        (purpleSticker == true)
            ? Positioned(
                left: 80,
                top: (purpleSticker == false) ? 15 : 3,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      purpleSticker = !purpleSticker;
                      if (greenSticker == true) {
                        greenSticker = false;
                      } else if (yellowSticker == true) {
                        yellowSticker = false;
                      }
                      pageIndex = 1;

                      if (greenSticker == false &&
                          purpleSticker == false &&
                          yellowSticker == false) {
                        setState(() {
                          runAnimation(40);
                          pageIndex = 0;
                        });
                      }
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xFFAA46FF),
                    ),
                    child: Icon(
                      Icons.share,
                      size: 20,
                      color: Color(0xFFcc91ff),
                    ),
                  ),
                ),
              )
            : Container(),
        (greenSticker == true)
            ? Positioned(
                left: 40,
                top: (greenSticker == false) ? 15 : 3,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      greenSticker = !greenSticker;
                      if (purpleSticker == true) {
                        purpleSticker = false;
                      } else if (yellowSticker == true) {
                        yellowSticker = false;
                      }
                      pageIndex = 0;

                      if (greenSticker == false &&
                          purpleSticker == false &&
                          yellowSticker == false) {
                        setState(() {
                          runAnimation(40);
                          pageIndex = 0;
                        });
                      }
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xFF46FFAE),
                    ),
                    child: Icon(
                      Icons.my_library_books,
                      size: 20,
                      color: Color(0xFFc9ffe7),
                    ),
                  ),
                ),
              )
            : Container(),
        (yellowSticker == true)
            ? Positioned(
                left: 120,
                top: (yellowSticker == false) ? 15 : 3,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      yellowSticker = !yellowSticker;
                      if (purpleSticker == true) {
                        purpleSticker = false;
                      } else if (greenSticker == true) {
                        greenSticker = false;
                      }
                      pageIndex = 2;

                      if (greenSticker == false &&
                          purpleSticker == false &&
                          yellowSticker == false) {
                        setState(() {
                          runAnimation(40);
                          pageIndex = 0;
                        });
                      }
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xFFffab51),
                    ),
                    child: Icon(
                      Icons.mediation,
                      size: 20,
                      color: Color(0xFFffcb94),
                    ),
                  ),
                ),
              )
            : Container(),
      ]),
    );
  }
}
