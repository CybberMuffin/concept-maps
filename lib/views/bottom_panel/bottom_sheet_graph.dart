import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/views/widgets/dots_indicator.dart';
import 'dart:math';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:concept_maps/views/painter/paint_bottom_graph.dart';

class BottomSheetGraph extends StatefulWidget {
  @override
  _BottomSheetGraphState createState() => _BottomSheetGraphState();
}

class _BottomSheetGraphState extends State<BottomSheetGraph> with SingleTickerProviderStateMixin {
  Node node;
  List<Node> tree;
  List<Node> newNodes = [];
  MapModel map;
  List<Widget> widgets = [];

  Animation<double> animation, curve;
  AnimationController animationController;
  double bottomSheetCof = 0.5;

  void runAnimation(double velocity) {
    curve = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    animation =
        animationController.drive(CurveTween(curve: Curves.easeInOut)).drive(Tween<double>(begin: velocity, end: 0));
    animationController.forward(from: 0.0);
  }

  void addWidget(Node node) {
    TextPainter textPainter =
        TextPainter(text: TextSpan(text: node.title), maxLines: 1, textDirection: TextDirection.ltr)
          ..layout(minWidth: 0, maxWidth: double.infinity);
    double textWidth = textPainter.width;

    widgets.add(Positioned(
      top: node.y - node.r,
      left: node.x - node.r,
      child: GestureDetector(
        onTap: () {
          Provider.of<AppProvider>(context, listen: false).setAnimationParam(node.id);
        },
        child: Container(
          height: 2 * node.r,
          width: 2 * node.r,
          decoration: BoxDecoration(
              color: node.sideColor,
              border: Border.all(color: node.mainColor, width: 3),
              borderRadius: BorderRadius.circular(2 * node.r)),
        ),
      ),
    ));

    widgets.add(Positioned(
        top: node.y + node.r,
        left: node.x - textWidth * 0.63,
        child: Container(
          child: Text(
            node.title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        )));
  }

  void addBorderWidget(Node node) {
    final size = MediaQuery.of(context).size;
    widgets.add(Positioned(
      top: node.y,
      child: GestureDetector(
        onTap: () {
          Provider.of<AppProvider>(context, listen: false).setAnimationParam(node.id);
        },
        child: Container(
          height: 4 * node.r,
          width: node.x * 2,
          decoration: BoxDecoration(color: Color(0xffffffff)),
        ),
      ),
    ));

    List<bool> dots = [];
    tree.firstWhere((a) => a.id == node.id).child.forEach((element) {
      if (node.child.contains(element)) {
        dots.insert(0, true);
      } else {
        dots.insert(0, false);
      }
    });

    widgets.add(Positioned(
      top: 0,
      child: Container(
        width: size.width - 30,
        child: Text(
          "Child nodes of " + node.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: node.r / 2,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ));

    widgets.add(Positioned(
      top: node.r / 2 + 8,
      child: DotsIndicator(dots),
    ));
  }

  void addBackWidget(Node node) {
    widgets.add(Positioned(
      top: node.y - 1.3 * node.r,
      left: node.x - node.r,
      child: Container(
          height: 2 * node.r,
          width: 2 * node.r,
          //color: Color(0xff2f0df4),
          child: Container(
            child: Transform.rotate(
              angle: 90 * pi / 180,
              child: IconButton(
                onPressed: () {
                  Provider.of<AppProvider>(context, listen: false).setAnimationParam(node.id);
                },
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xff2a9df4),
                ),
              ),
            ),
          )),
    ));
  }

  void addNode(Node removeNode, String nextId, int index, double startDeg, bool isFrontAdd) {
    if (!isFrontAdd) {
      newNodes.insert(
          index, Node(nextId, [], node.id, map.concepts[map.concepts.indexWhere((a) => a.id == nextId)].concept));
    } else {
      newNodes.add(Node(nextId, [], node.id, map.concepts[map.concepts.indexWhere((a) => a.id == nextId)].concept));
    }

    newNodes[0].child.add(nextId);

    double x = removeNode.bigR * cos(startDeg * (pi / 180.0)) + newNodes[0].x;
    double y = removeNode.bigR * sin(startDeg * (pi / 180.0)) + newNodes[0].y;
    newNodes[index].x = x;
    newNodes[index].y = y;
    newNodes[index].deg = startDeg;
    newNodes[index].r = removeNode.r;
    newNodes[index].bigR = removeNode.bigR;
  }

  void removeAndAddNode(Node removeNode, String nextId, int index, double startDeg) {
    newNodes.remove(removeNode);
    newNodes[0].child.remove(removeNode.id);

    if (startDeg == -180.0) {
      newNodes.insert(
          index, Node(nextId, [], node.id, map.concepts[map.concepts.indexWhere((a) => a.id == nextId)].concept));
    } else if (startDeg == 0.0) {
      newNodes.add(Node(nextId, [], node.id, map.concepts[map.concepts.indexWhere((a) => a.id == nextId)].concept));
    }

    newNodes[0].child.add(nextId);

    double x = removeNode.bigR * cos(startDeg * (pi / 180.0)) + newNodes[0].x;
    double y = removeNode.bigR * sin(startDeg * (pi / 180.0)) + newNodes[0].y;
    newNodes[index].x = x;
    newNodes[index].y = y;
    newNodes[index].deg = startDeg;
    newNodes[index].r = removeNode.r;
    newNodes[index].bigR = removeNode.bigR;
    //newNodes.length - 1
  }

  void removeNode(Node node) {
    newNodes.remove(node);
    newNodes[0].child.remove(node.id);
  }

  void addNewNode(Node node) {
    newNodes.add(node);
    newNodes[0].child.add(node.id);
  }

  void insertNewNode(Node node, int index) {
    newNodes.insert(index, node);
    newNodes[0].child.add(node.id);
  }

  void impact(double deg) {
    if (deg == -180.0) {
      HapticFeedback.lightImpact();
    }
  }

  void resetLeftMoreThenFour(double displ) {
    double currentDeg;
    double a;
    Node nodeToAdd;
    bool removeFirst = false;
    bool addLast = false;
    newNodes.asMap().forEach((key, element) {
      impact(element.deg);
      if (key > 1) {
        if (key == 2) {
          displ = (displ * 180.0) / (pi * element.bigR);
          currentDeg = element.deg + displ;

          a = asin(element.r / element.bigR) * (180.0 / pi);
          if (element.deg <= -181.0 - a) {
            removeFirst = true;
          }
        } else if (key > 2) {
          currentDeg += 45.0;
        }
        element.x = element.bigR * cos((currentDeg) * (pi / 180.0)) + newNodes[0].x;
        element.y = element.bigR * sin((currentDeg) * (pi / 180.0)) + newNodes[0].y;
        element.deg = currentDeg;
        addWidget(element);
      }

      if (key == newNodes.length - 1) {
        a = asin(element.r / element.bigR) * (180.0 / pi);
        if (element.deg <= -45.0 + a) {
          addLast = true;
          int index = node.child.indexWhere((a) => a == element.id) + 1;
          if (index > node.child.length - 1) {
            index = 0;
          }
          String id = node.child[index];
          nodeToAdd = tree.firstWhere((a) => a.id == id);
          nodeToAdd.bigR = element.bigR;
          nodeToAdd.r = element.r;
          nodeToAdd.x = newNodes[0].x;
          nodeToAdd.y = newNodes[0].y;
        }
      }
    });
    if (removeFirst) {
      removeNode(newNodes[2]);
    }
    if (addLast) {
      addNewNode(nodeToAdd);
    }
  }

  void resetLeftLessThenFour(double displ) {
    double currentDeg;
    double a;
    bool c = true;
    newNodes.asMap().forEach((key, element) {
      impact(element.deg);
      if (key > 1) {
        a = asin(element.r / element.bigR) * (180.0 / pi);
        if (element.deg >= -180.0 + 2 * a && c) {
          if (key == 2) {
            displ = (displ * 180.0) / (pi * element.bigR);
            currentDeg = element.deg + displ;
          } else if (key > 2) {
            currentDeg += 45.0;
          }
          element.x = element.bigR * cos((currentDeg) * (pi / 180.0)) + newNodes[0].x;
          element.y = element.bigR * sin((currentDeg) * (pi / 180.0)) + newNodes[0].y;
          element.deg = currentDeg;
          addWidget(element);
        } else {
          c = false;
          addWidget(element);
        }
      }
    });
  }

  void resetLeft(double displ) {
    widgets.clear();

    if (tree.firstWhere((a) => a.id == newNodes[0].id).child.length <= 4) {
      resetLeftLessThenFour(displ);
    } else {
      resetLeftMoreThenFour(displ);
    }
  }

  void resetRightLessThenFour(displ) {
    double currentDeg;
    double a;
    bool c = true;
    int childMax = newNodes.length - 1;
    for (int i = childMax; i > 1; i--) {
      impact(newNodes[i].deg);
      a = asin(newNodes[i].r / newNodes[i].bigR) * (180.0 / pi);
      if (newNodes[i].deg <= 0 - 2 * a && c) {
        if (i == childMax) {
          displ = (displ * 180.0) / (pi * newNodes[i].bigR);
          currentDeg = newNodes[i].deg + displ;
        } else if (i < childMax) {
          currentDeg -= 45.0;
        }
        newNodes[i].x = newNodes[i].bigR * cos((currentDeg) * (pi / 180.0)) + newNodes[0].x;
        newNodes[i].y = newNodes[i].bigR * sin((currentDeg) * (pi / 180.0)) + newNodes[0].y;
        newNodes[i].deg = currentDeg;
        addWidget(newNodes[i]);
      } else {
        c = false;
        addWidget(newNodes[i]);
      }
    }
  }

  void resetRightMoreThenFour(displ) {
    double currentDeg;
    double a;
    Node nodeToAdd;
    bool removeLast = false;
    bool addFirst = false;
    int childMax = newNodes.length - 1;
    for (int i = childMax; i > 1; i--) {
      impact(newNodes[i].deg);
      if (i == childMax) {
        displ = (displ * 180.0) / (pi * newNodes[i].bigR);
        currentDeg = newNodes[i].deg + displ;

        a = asin(newNodes[i].r / newNodes[i].bigR) * (180.0 / pi);
        if (newNodes[i].deg >= 0.0 + a) {
          removeLast = true;
        }
      } else if (i < childMax) {
        currentDeg -= 45.0;
      }
      newNodes[i].x = newNodes[i].bigR * cos((currentDeg) * (pi / 180.0)) + newNodes[0].x;
      newNodes[i].y = newNodes[i].bigR * sin((currentDeg) * (pi / 180.0)) + newNodes[0].y;
      newNodes[i].deg = currentDeg;
      addWidget(newNodes[i]);

      if (i == 2) {
        a = asin(newNodes[i].r / newNodes[i].bigR) * (180.0 / pi);
        if (newNodes[i].deg >= -140 - a) {
          addFirst = true;
          int index = node.child.indexWhere((a) => a == newNodes[i].id) - 1;
          if (index < 0) {
            index = node.child.length - 1;
          }
          String id = node.child[index];
          nodeToAdd = tree.firstWhere((a) => a.id == id);
          nodeToAdd.bigR = newNodes[i].bigR;
          nodeToAdd.r = newNodes[i].r;
          nodeToAdd.x = newNodes[0].x;
          nodeToAdd.y = newNodes[0].y;
        }
      }
    }
    if (removeLast) {
      removeNode(newNodes[newNodes.length - 1]);
    }
    if (addFirst) {
      insertNewNode(nodeToAdd, 2);
    }
  }

  void resetRight(double displ) {
    widgets.clear();

    if (tree.firstWhere((a) => a.id == newNodes[0].id).child.length <= 4) {
      resetRightLessThenFour(displ);
    } else {
      resetRightMoreThenFour(displ);
    }
  }

  void resetPosition(Offset offset) {
    double displ = offset.dx.sign * sqrt(pow(offset.dx, 2) + pow(offset.dy, 2));
    if (offset.dx.sign == -1.0) {
      resetLeft(displ);
    } else if (offset.dx.sign == 1.0) {
      resetRight(displ);
    }
    addBorderWidget(newNodes[0]);
    addWidget(newNodes[0]);
    addBackWidget(newNodes[1]);
  }

  void resetPosition2(Offset offset) {
    widgets.clear();
    Node n1, n2;
    String nextId;
    Node removeNode;
    double newDeg;
    int index;
    double currentDeg;
    bool isFrontAdd;
    newNodes.asMap().forEach((i, element) {
      if (element.parent != "-1" && element.parent != "-2") {
        //if(i == 1 || i == 2){
        if (i >= 1) {
          double displ = offset.dx.sign * sqrt(pow(offset.dx, 2) + pow(offset.dy, 2));
          displ = (displ * 180.0) / (pi * element.bigR);
          currentDeg = element.deg + displ;
          element.x = element.bigR * cos((currentDeg) * (pi / 180.0)) + newNodes[0].x;
          element.y = element.bigR * sin((currentDeg) * (pi / 180.0)) + newNodes[0].y;
          element.deg = currentDeg;
        } else {
          currentDeg += 45.0;
          element.x = element.bigR * cos((currentDeg) * (pi / 180.0)) + newNodes[0].x;
          element.y = element.bigR * sin((currentDeg) * (pi / 180.0)) + newNodes[0].y;
          element.deg = currentDeg;
        }

        double a = asin(element.r / element.bigR) * (180.0 / pi);
        if (element.deg <= -181.0 - a) {
          int nextIndex = node.child.indexWhere((a) => a == element.id) + 4;
          if (nextIndex > node.child.length - 1) {
            nextIndex = 3 - (node.child.length - 1 - (nextIndex - 4));
          }
          nextId = node.child[nextIndex];
          index = newNodes.length - 1;
          newDeg = 0.0;
          removeNode = element;
        } else if (element.deg >= a + 1) {
          int prevIndex = node.child.indexWhere((a) => a == element.id) - 4;
          if (prevIndex < 0) {
            prevIndex = node.child.length + prevIndex;
          }
          nextId = node.child[prevIndex];
          index = 2;
          newDeg = -180.0;
          removeNode = element;
        }
      }
      if (element.parent != "-2" && element.parent != "-1") {
        addWidget(element);
      } else if (element.parent == "-1") {
        n1 = element;
      } else if (element.parent == "-2") {
        n2 = element;
      }
    });

    if (removeNode != null) {
      removeAndAddNode(removeNode, nextId, index, newDeg);
    }
    addBorderWidget(n1);
    addWidget(n1);
    if (n2 != null) {
      addBackWidget(n2);
    }
  }

  void setPosition() {
    widgets.clear();
    newNodes.clear();
    final size = MediaQuery.of(context).size;
    double deltaDeg = -45.0;
    int c = (node.child.length > 4) ? 4 : node.child.length;
    double deltaDegNum = (c - 1) / 2.0;
    double deg = deltaDegNum * deltaDeg - 90;
    double circleR = (size.height * bottomSheetCof - 45) / 11;
    double r = circleR * 5.5;
    newNodes.add(Node(node.id, [], "-1", node.title, node.mainColor, node.sideColor));
    newNodes[0].x = size.width / 2 - 15;
    newNodes[0].y = size.height * bottomSheetCof - 40 - circleR * 3.2;
    newNodes[0].r = circleR * 1.3;

    newNodes.add(Node(node.parent, [node.id], "-2", ""));
    newNodes[1].mainColor = node.mainColor;
    newNodes[1].x = size.width / 2 - 15;
    newNodes[1].y = size.height * bottomSheetCof - 40 - circleR * 0.5;
    newNodes[1].r = circleR;
    if (node.parent != "-1") {
      newNodes[1].r = circleR;
    } else {
      newNodes[1].r = 0;
    }

    int i = 0;
    while (i < node.child.length) {
      Node temp = tree.firstWhere((a) => a.id == node.child[i]);
      newNodes.add(Node(
        node.child[i],
        [],
        node.id,
        temp.title,
        temp.mainColor,
        temp.sideColor,
        temp.d,
      ));
      newNodes[0].child.add(node.child[i]);
      double x = r * cos(deg * (pi / 180.0)) + newNodes[0].x;
      double y = r * sin(deg * (pi / 180.0)) + newNodes[0].y;
      newNodes[newNodes.length - 1].x = x;
      newNodes[newNodes.length - 1].y = y;
      newNodes[newNodes.length - 1].deg = deg;
      newNodes[newNodes.length - 1].r = circleR;
      newNodes[newNodes.length - 1].bigR = r;
      newNodes[newNodes.length - 1].isAspect = temp.isAspect;
      addWidget(newNodes[newNodes.length - 1]);
      deg -= deltaDeg;

      i++;
      if (i == 4) {
        break;
      }
    }
    addBorderWidget(newNodes[0]);
    addWidget(newNodes[0]);
    if (node.parent != "-1") {
      addBackWidget(newNodes[1]);
    }
  }

  @override
  void initState() {
    animationController = AnimationController(duration: Duration(seconds: 1), vsync: this)
      ..addListener(() {
        setState(() {
          resetPosition(Offset(animation.value, 0));
        });
      });

    map = context.read<AppProvider>().currentMap;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    node = Provider.of<AppProvider>(context, listen: true).focusNode;
    tree = Provider.of<AppProvider>(context, listen: true).tree;
    setPosition();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<AppProvider>(
        builder: (context, value, _) => GestureDetector(
            onPanDown: (details) {},
            onPanUpdate: (details) {
              setState(() {
                resetPosition(details.delta);
              });
            },
            onPanEnd: (details) {
              setState(() {
                runAnimation(details.velocity.pixelsPerSecond.dx / 50);
              });
            },
            child: Container(
                width: size.width - 30,
                height: size.height * 0.4,
                //color: Color(0xffd04fff),
                child: CustomPaint(
                    painter: PaintBottomGraph(newNodes, value.focusNode),
                    child: Stack(
                      children: widgets,
                    )))));
  }
}
