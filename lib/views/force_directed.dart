import 'package:flutter/material.dart';
import 'package:concept_maps/controllers/force_directed_controller.dart';
import 'package:concept_maps/views/paint_graph.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/physics.dart';

class ForceDirected extends StatefulWidget {
  var relations;
  var concepts;

  ForceDirected(this.relations, this.concepts);

  @override
  _ForceDirectedState createState() =>
      _ForceDirectedState(this.relations, this.concepts);
}

class _ForceDirectedState extends State<ForceDirected>
    with SingleTickerProviderStateMixin{

  AnimationController animationController;
  Animation<Matrix4> animation;

  _ForceDirectedState(this.relations, this.concepts);

  ForceDirectedController controller;
  MediaQueryData size;
  var relations;
  var concepts;
  var flag;
  TransformationController transformationController = TransformationController();

  void runAnimation(Offset position){
    Matrix4 matrix = Matrix4.copy(transformationController.value);
    matrix.row0 = Vector4(1, 0, 0, -position.dx + size.size.width/2);
    matrix.row1 = Vector4(0, 1, 0, -position.dy + size.size.height/2);
    //matrix.row3 = Vector4(position.dx, position.dy, 0, 1);

    animation = animationController.drive(
      Matrix4Tween(
        begin: transformationController.value,
        end: matrix
      )
    );

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -5);

    animationController.animateWith(simulation);

  }

  void fillWidg() {
    var node_size = 80.0;
    controller.widgets.clear();
    controller.vertices.forEach((element) {
      controller.widgets.add(Positioned(
        top: element.position.y - node_size / 2,
        left: element.position.x - node_size / 2,
        child: GestureDetector(
          onPanDown: (details) {
            element.isOn = true;
          },
          onPanUpdate: (details) {
            setState(() {
              //print(details.delta.dx);
              //print("..........................");
              //print(element.position.x);

              controller.forceCalc(size, 1);
              element.position.x += details.delta.dx;
              element.position.y += details.delta.dy;
              fillWidg();
              //print(element.position.x);
              //print("___________________________");
            });
          },
          onPanEnd: (details) {
            element.isOn = false;
            setState(() {
              controller.forceCalc(size, 50);
              fillWidg();
            });
          },
          onTap: (){
            runAnimation(Offset(element.position.x, element.position.y));
          },
          child: Container(
            height: node_size,
            width: node_size,
            decoration: BoxDecoration(
                color: Color(0xffd0efff),
                border: Border.all(color: Color(0xff2a9df4), width: 3),
                borderRadius: BorderRadius.circular(node_size)),
          ),
        ),
      ));
    });
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(microseconds: 200),
        vsync: this
    );
    animationController.addListener(() {
      setState(() {
        transformationController.value = animation.value;
        print(transformationController.value);
        print("///////////////////////////////");

      });
    });
    flag = false;
    controller = new ForceDirectedController(relations, concepts);
    controller.crToVE();
    Offset frame = Offset(3000, 3000);
    controller.setVerticesPos(frame);
    controller.forceCalc(frame, 600);
    fillWidg();
    flag = true;
    transformationController.value = Matrix4(
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context);

    return Scaffold(
        body: Container(
          child: InteractiveViewer(
            constrained: false,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            minScale: 0.1,
            maxScale: 5.6,
            transformationController: transformationController,
            child: Container(
              width: 3000,
              height: 3000,
              child: CustomPaint(
                painter: PaintGraph(controller.edges, controller.vertices, flag),
                child: Stack(
                  children: controller.widgets,
                ),
              ),
            ),
          )
        )
    );
  }
}
