import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/views/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:concept_maps/controllers/force_directed_controller.dart';
import 'package:concept_maps/views/paint_graph.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/physics.dart';
import 'package:provider/provider.dart';
import 'package:concept_maps/views/bottom_sheet_pannel.dart';
import 'package:concept_maps/models/graph_entities/node.dart';

class ForceDirected extends StatefulWidget {
  @override
  _ForceDirectedState createState() => _ForceDirectedState();
}

class _ForceDirectedState extends State<ForceDirected>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<Matrix4> animation;

  Node focusNode;
  MapModel map;
  ForceDirectedController controller;
  var flag;
  Offset frame;
  TransformationController transformationController =
      TransformationController();

  void runAnimation(Offset position, double scale) {
    final size = MediaQuery.of(context).size;
    Matrix4 matrix = Matrix4.copy(transformationController.value);
    matrix.row0 = Vector4(scale, 0, 0, -position.dx*scale + size.width / 2);
    matrix.row1 = Vector4(0, scale, 0, -position.dy*scale + size.height*0.25);
    matrix.row2 = Vector4(0, 0, scale, 0);
    //matrix.row3 = Vector4(position.dx, position.dy, 0, 1);

    animation = animationController.drive(
        Matrix4Tween(begin: transformationController.value, end: matrix));

    const spring = SpringDescription(
      mass: 30,
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
    controller.vertices.forEach((element) {

      TextPainter textPainter = TextPainter(
          text: TextSpan(text: element.title),
          maxLines: 1,
          textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: double.infinity);
      double textWidth = textPainter.width;


      controller.titles.add(Positioned(
          top: element.position.y + nodeSize / 2,
          left: element.position.x - textWidth,
          child: Text(
            element.title,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          )));

      controller.widgets.add(Positioned(
        top: element.position.y - nodeSize / 2,
        left: element.position.x - nodeSize / 2,
        child: GestureDetector(
          onPanDown: (details) {
            element.isOn = true;
          },
          onPanUpdate: (details) {
            setState(() {
              controller.forceCalc(frame, 1);
              element.position.x += details.delta.dx;
              element.position.y += details.delta.dy;
              fillWidg();
            });
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
              context.read<AppProvider>().setFocusNode(controller.balloon
                  .three[controller.balloon.three.indexWhere((a) => a.id == element.id)]);
            });
          },
          onDoubleTap: () {
            setState(() {
              runAnimation(Offset(element.position.x, element.position.y), 0.3);
              context.read<AppProvider>().setFocusNode(controller.balloon
                  .three[controller.balloon.three.indexWhere((a) => a.id == element.id)]);
            });
          },
          child: Container(
            height: nodeSize,
            width: nodeSize,
            decoration: BoxDecoration(
                color: Color(0xffd0efff),
                border: Border.all(color: Color(0xff2a9df4), width: 3),
                borderRadius: BorderRadius.circular(nodeSize)),
          ),
        ),
      ));
    });
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(microseconds: 200), vsync: this);
    animationController.addListener(() {
      setState(() {
        transformationController.value = animation.value;
      });
    });

    flag = false;
    map = context.read<AppProvider>().currentMap;
    controller = ForceDirectedController(map.relations, map.concepts);
    controller.crToVE();
    frame = Offset(4000, 4000);
    controller.setVerticesPos(frame);
    controller.forceCalc(frame, 50);
    fillWidg();
    flag = true;
    //print(controller.vertices.indexWhere((element) => element.id == controller.rootId.toString()));
    //print(controller.concepts[controller.concepts.indexWhere((element) => element.id == controller.rootId)]);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final size = MediaQuery.of(context).size;

    Vector2 v = Vector2.copy(controller
        .vertices[controller.vertices.indexWhere(
            (element) => element.id == controller.rootId.toString())]
        .position);
    context.read<AppProvider>().focusNode = Node("", [], "", controller.
    vertices[controller.vertices.indexWhere((element) =>
    element.id == controller.rootId.toString())].title);
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
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: BottomSheetPannel(),
        drawer: DrawerMenu(),
        appBar: AppBar(title: Text("Concept Map")),
        body: Container(
          child: InteractiveViewer(
            constrained: false,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            minScale: 0.1,
            maxScale: 5.6,
            onInteractionUpdate: (a) {
              //print(transformationController.value);
              // print("__________________");
            },
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
        ));
  }
}
