import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/views/bottom_panel/bottom_pannel.dart';
import 'package:concept_maps/views/bottom_panel/bottom_sheet_graph.dart';
import 'package:concept_maps/views/bottom_panel/bottom_sheet_related_concepts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  double bottomSheetCof = 0.5;

  dragPanelUp() {
    final size = MediaQuery.of(context).size;
    if (height == 40) {
      setState(() {
        pageIndex = 0;
        runAnimation(size.height * bottomSheetCof);
      });
    } else if (height == size.height * bottomSheetCof &&
        purpleSticker != true) {
      setState(() {
        runAnimation(size.height - 115);
      });
    }
  }

  dragPanelDown() {
    final size = MediaQuery.of(context).size;
    if (height == size.height * bottomSheetCof) {
      setState(() {
        runAnimation(40);
        yellowSticker = false;
        greenSticker = false;
        purpleSticker = false;
      });
    } else if (height == size.height - 115 && yellowSticker != true) {
      setState(() {
        runAnimation(size.height * bottomSheetCof);
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
      if (purpleSticker == false && yellowSticker == false && pageIndex == 0) {
        greenSticker = true;
        runAnimation(size.height * bottomSheetCof);
      }
      if (greenSticker == false && yellowSticker == false && pageIndex == 1) {
        purpleSticker = true;
        runAnimation(size.height * bottomSheetCof);
      }

      if (greenSticker == false && purpleSticker == false && pageIndex == 2) {
        yellowSticker = true;
        runAnimation(size.height - 115);
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
                    if (height != 40) {
                      setState(() {
                        purpleSticker = !purpleSticker;
                        if (height == size.height - 115) {
                          runAnimation(size.height * bottomSheetCof);
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
                    }
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
                    if (height != 40) {
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
                    }
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
                    if (height != 40) {
                      setState(() {
                        yellowSticker = !yellowSticker;
                        if (height == size.height * bottomSheetCof) {
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
                    }
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
                    color: Colors.grey.withOpacity(bottomSheetCof),
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
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    // Up Swipe
                    if (details.delta.dy < 0) {
                      dragPanelUp();
                      if (greenSticker == false && purpleSticker == false) {
                        greenSticker = true;
                      }
                    } else if (details.delta.dy > 0) {
                      // Down swipe
                      dragPanelDown();
                      if (height ==
                          MediaQuery.of(context).size.height * bottomSheetCof) {
                        if (greenSticker == true || purpleSticker == true) {
                          greenSticker = false;
                          purpleSticker = false;
                        }
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
