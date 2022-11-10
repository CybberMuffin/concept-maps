import 'package:concept_maps/graph_controllers/force_directed_controller.dart';
import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/providers/user_provider.dart';
import 'package:concept_maps/views/painter/paint_graph.dart';
import 'package:concept_maps/views/widgets/drawer_menu.dart';
import 'package:concept_maps/views/widgets/search_app_bar.dart';
import 'package:concept_maps/views/widgets/texts/main_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:concept_maps/views/bottom_panel/bottom_sheet_pannel.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';

import 'bottom_panel/bottom_sheet_pannel.dart';

class ForceDirected extends StatefulWidget {
  final String title;

  const ForceDirected({Key key, this.title}) : super(key: key);
  @override
  _ForceDirectedState createState() => _ForceDirectedState();
}

class _ForceDirectedState extends State<ForceDirected>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<Matrix4> animation;

  Animation<double> graphAnimation, graphCurve;
  AnimationController graphAnimationController;

  Node focusNode;
  bool graphFlag;
  int count;
  Vector2 temp;
  MapModel map;
  ForceDirectedController controller;
  var flag;
  Offset frame;
  TransformationController transformationController =
      TransformationController();
  bool errorDetected = false;

  void runGraphAnimation(Duration d) {
    graphAnimationController.duration =
        Duration(microseconds: d.inMicroseconds);
    graphCurve = CurvedAnimation(
        parent: graphAnimationController, curve: Curves.easeInOut);

    graphAnimationController.forward(from: 0.0);
  }

  void runAnimation(Offset position, double scale) {
    final size = MediaQuery.of(context).size;
    Matrix4 matrix = Matrix4.copy(transformationController.value);
    matrix.row0 = Vector4(scale, 0, 0, -position.dx * scale + size.width / 2);
    matrix.row1 =
        Vector4(0, scale, 0, -position.dy * scale + size.height * 0.2);
    matrix.row2 = Vector4(0, 0, scale, 0);
    //matrix.row3 = Vector4(position.dx, position.dy, 0, 1);

    animation = animationController.drive(
        Matrix4Tween(begin: transformationController.value, end: matrix));

    const spring = SpringDescription(
      mass: 15,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -5);

    animationController.animateWith(simulation);
  }

  void fillWidg() {
    var nodeSize = 100.0;
    controller.widgets.clear();
    controller.titles.clear();

    controller.edges.forEach((element) {
      double a, c, angle = 0;
      if (element.v.position.y <= element.u.position.y &&
          element.v.position.x <= element.u.position.x) {
        a = Vector2(element.v.position.x - element.v.position.x,
                element.v.position.y - element.u.position.y)
            .length;
        c = Vector2(element.v.position.x - element.u.position.x,
                element.v.position.y - element.u.position.y)
            .length;
        angle = asin(a / c);
      } else if (element.u.position.y <= element.v.position.y &&
          element.v.position.x <= element.u.position.x) {
        a = Vector2(element.v.position.x - element.v.position.x,
                element.v.position.y - element.u.position.y)
            .length;
        c = Vector2(element.v.position.x - element.u.position.x,
                element.v.position.y - element.u.position.y)
            .length;
        angle = -asin(a / c);
      } else if (element.v.position.y <= element.u.position.y &&
          element.u.position.x <= element.v.position.x) {
        a = Vector2(element.v.position.x - element.v.position.x,
                element.v.position.y - element.u.position.y)
            .length;
        c = Vector2(element.v.position.x - element.u.position.x,
                element.v.position.y - element.u.position.y)
            .length;
        angle = -pi - asin(a / c);
      } else if (element.u.position.y <= element.v.position.y &&
          element.u.position.x <= element.v.position.x) {
        a = Vector2(element.v.position.x - element.v.position.x,
                element.v.position.y - element.u.position.y)
            .length;
        c = Vector2(element.v.position.x - element.u.position.x,
                element.v.position.y - element.u.position.y)
            .length;
        angle = -pi + asin(a / c);
      }

      controller.widgets.add(Positioned(
        top: element.v.position.y - 25,
        left: element.v.position.x + 25,
        child: Transform.rotate(
          angle: angle,
          alignment: Alignment.centerLeft,
          child: InkWell(
            enableFeedback: false,
            canRequestFocus: false,
            highlightColor: Color(0x0032f16f),
            hoverColor: Color(0x0032f16f),
            splashColor: Color(0x0032f16f),
            onTap: () {
              setState(() {
                runAnimation(
                    Offset((element.u.position.x + element.v.position.x) / 2,
                        (element.u.position.y + element.v.position.y) / 2),
                    0.5);
                context.read<AppProvider>().setFocusNode(
                    controller.balloon.three[controller.balloon.three
                        .indexWhere((a) => a.id == element.u.id)]);
                context.read<AppProvider>().animationStart = false;
                context.read<AppProvider>().isEdgeActive = true;
                context.read<AppProvider>().focusEdge = element;
                context.read<AppProvider>().focusTitle =
                    element.u.fullTitle + " 一 " + element.v.fullTitle;
                context.read<AppProvider>().setBottomSheetFlag(true);
              });
            },
            child: Container(
              width: Vector2(element.u.position.x - element.v.position.x,
                      element.u.position.y - element.v.position.y)
                  .length,
              height: 50,
            ),
          ),
        ),
      ));
    });

    controller.vertices.forEach((element) {
      TextPainter textPainter = TextPainter(
          text: TextSpan(text: element.title),
          maxLines: 1,
          textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: double.infinity);
      double textWidth = textPainter.width;

      controller.titles.add(Positioned(
          top: element.position.y + element.size / 2,
          left: element.position.x - textWidth,
          child: Text(
            element.title,
            //+"\n"+element.atr.x.toString()+"\n"+element.atr.y.toString()
            //+"\n"+element.displacement.x.toString()+"\n"+element.displacement.y.toString(),
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          )));

      controller.widgets.add(Positioned(
        top: element.position.y * graphAnimation.value +
            element.prevPosition.y * (1 - graphAnimation.value) -
            element.size / 2,
        left: element.position.x * graphAnimation.value +
            element.prevPosition.x * (1 - graphAnimation.value) -
            element.size / 2,
        child: GestureDetector(
          onPanDown: (details) {
            element.isOn = true;
          },
          onPanUpdate: (details) {
            count++;
            temp.x += details.delta.dx;
            temp.y += details.delta.dy;
            if (count > 10) {
              count = 0;
              setState(() {
                graphFlag = false;
                element.prevPosition =
                    Vector2(element.position.x, element.position.y);
                Duration d = controller.forceCalc(frame, 1, 1);
                runGraphAnimation(d);
                element.position.x += temp.x;
                element.position.y += temp.y;
                temp = Vector2(0, 0);
                fillWidg();
              });
            }
          },
          onPanEnd: (details) {
            element.isOn = false;
            setState(() {
              fillWidg();
            });
          },
          onTap: () {
            setState(() {
              runAnimation(Offset(element.position.x, element.position.y), 0.7);
              context.read<AppProvider>().setFocusNode(controller.balloon.three[
                  controller.balloon.three
                      .indexWhere((a) => a.id == element.id)]);
              context.read<AppProvider>().isEdgeActive = false;
              context.read<AppProvider>().focusTitle = element.fullTitle;
              context.read<AppProvider>().animationStart = false;
              context.read<AppProvider>().setBottomSheetFlag(true);
            });
          },
          onDoubleTap: () {
            setState(() {
              runAnimation(Offset(element.position.x, element.position.y), 0.3);
              context.read<AppProvider>().setFocusNode(controller.balloon.three[
                  controller.balloon.three
                      .indexWhere((a) => a.id == element.id)]);
              context.read<AppProvider>().animationStart = false;
            });
          },
          child: Container(
            height: element.size,
            width: element.size,
            decoration: BoxDecoration(
                color: element.sideColor,
                border: Border.all(color: element.mainColor, width: 6),
                borderRadius: BorderRadius.circular(element.size)),
          ),
        ),
      ));
    });
    graphFlag = true;
  }

  @override
  void initState() {
    super.initState();
    try {
      Stopwatch s = Stopwatch();
      s.start();
      final map = context.read<AppProvider>().currentMap;
      map.age++;
      animationController = AnimationController(
          duration: Duration(microseconds: 200), vsync: this);
      animationController.addListener(() {
        setState(() {
          transformationController.value = animation.value;
        });
      });

      graphAnimationController = AnimationController(vsync: this);
      graphAnimationController.addListener(() {
        setState(() {});
      });
      graphAnimation = animationController
          .drive(CurveTween(curve: Curves.easeInOut))
          .drive(Tween<double>(begin: 0.0, end: 1.0));

      flag = false;
      graphFlag = true;
      context.read<AppProvider>().bottomSheetFlag = null;
      context.read<AppProvider>().animationStart = false;
      count = 10;
      temp = Vector2(0, 0);
      controller = ForceDirectedController(map);
      controller.crToVE();
      frame = Offset(controller.vertices.length.toDouble() * 800,
          controller.vertices.length.toDouble() * 800);
      controller.setVerticesPos(frame);
      controller.forceCalc(frame, 50, 50);
      context.read<AppProvider>().setTree(controller.balloon.three);
      List<String> viewedConceptIds =
          context.read<UserProvider>().viewedConceptIds;
      controller.setVerticesEdgesColors(
          controller.balloon.three, viewedConceptIds);
      fillWidg();
      flag = true;
      force = 50;
      print(s.elapsedMilliseconds);
    } catch (e) {
      print(e.toString());
      errorDetected = true;
    }
  }

  int force;

  void d() {
    if (force > 0) {
      Duration d = controller.forceCalc(frame, 1, force.toDouble());
      fillWidg();
      runGraphAnimation(d);
    }
    force--;
  }

  @override
  void didChangeDependencies() {
    Stopwatch ss = Stopwatch()..start();
    try {
      final size = MediaQuery.of(context).size;
      //d();
      if (Provider.of<AppProvider>(context).animationStart == true) {
        Vector2 v = controller
            .vertices[controller.vertices.indexWhere(
                (a) => a.id == Provider.of<AppProvider>(context).animationId)]
            .position;
        context.read<AppProvider>().isEdgeActive = false;
        context.read<AppProvider>().focusTitle = controller.vertices
            .firstWhere(
                (a) => a.id == Provider.of<AppProvider>(context).animationId)
            .fullTitle;
        runAnimation(Offset(v.x, v.y), 0.7);
        Provider.of<AppProvider>(context).bottomSheetFlag = true;
        context.read<AppProvider>().focusNode = controller.balloon.three[
            controller.balloon.three.indexWhere(
                (a) => a.id == Provider.of<AppProvider>(context).animationId)];
      } else if (Provider.of<AppProvider>(context).bottomSheetFlag == null) {
        context.read<AppProvider>().focusNode = Node(
            "",
            [],
            "",
            controller
                .vertices[controller.vertices.indexWhere(
                    (element) => element.id == controller.rootId.toString())]
                .title);

        Vector2 v = Vector2.copy(controller
            .vertices[controller.vertices.indexWhere(
                (element) => element.id == controller.rootId.toString())]
            .position);

        transformationController.value = Matrix4(
            0.2,
            0,
            0,
            0,
            0,
            0.2,
            0,
            0,
            0,
            0,
            0.2,
            0,
            -v.x * 0.2 + size.width / 2,
            -v.y * 0.2 + size.height / 2,
            0,
            1);
      }
      print(ss.elapsedMilliseconds);
    } catch (e) {
      print(e.toString());
      errorDetected = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    animationController.dispose();
    graphAnimationController.dispose();
    super.dispose();
  }

  Widget get mapNotAvailableText =>
      Center(child: MainText('Map for this Material is Not Available'));

  @override
  Widget build(BuildContext context) {
    final map = context.read<AppProvider>().currentMap;

    return Scaffold(
      bottomSheet: errorDetected ? null : BottomSheetPannel(),
      appBar: SearchAppBar(
        barTitle: widget.title,
        isSearchAvailable: !errorDetected,
      ),
      drawer: errorDetected ? null : DrawerMenu(title: widget.title),
      body: Container(
        child: errorDetected
            ? mapNotAvailableText
            : InteractiveViewer(
                constrained: false,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                minScale: 0.01,
                maxScale: 5.6,
                onInteractionUpdate: (a) {},
                transformationController: transformationController,
                child: Container(
                  width: frame.dx,
                  height: frame.dy,
                  child: CustomPaint(
                    painter:
                        PaintGraph(controller.edges, controller.vertices, flag),
                    child: Stack(
                      children: [
                        ...controller.widgets,
                        ...controller.titles,
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
