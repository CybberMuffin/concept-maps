import 'package:flutter/cupertino.dart';
import 'package:concept_maps/models/graph_entities/edge.dart';
import 'package:concept_maps/models/graph_entities/vertice.dart';
import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';

class PaintBottomGraph extends CustomPainter {

  List<Node> nodes;
  Node n;
  PaintBottomGraph(this.nodes, this.n);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 4
      ..isAntiAlias = true;

    Node main = nodes[nodes.indexWhere((a) => a.parent == "-1")];
    canvas.drawCircle(Offset(main.x, main.y), main.r, paint);

    /*
    print("!!!!!!!!!!!!");
    main.child.forEach((element) {
      print(element);
    });
    print("@@@@@@@@@@@@@@@@@@");

    nodes.forEach((element) {
      print(element.id);
    });
    print("::::::::::::::::::");
     */

    /*
    if(nodes.indexWhere((a) => a.parent == "-2") == 1) {
      Node parent = nodes[nodes.indexWhere((a) => a.parent == "-2")];
      canvas.drawLine(Offset(parent.x - main.r, parent.y - main.r), Offset(parent.x, parent.y), paint);
      canvas.drawLine(Offset(parent.x + main.r, parent.y - main.r), Offset(parent.x, parent.y), paint);
    }

     */


    main.child.forEach((element) {
      Node cNode = nodes.firstWhere((a) => a.id == element);
      if(cNode.isAspect == "1"){
        paint.color = cNode.sideColor;
      }else{
        paint.color = main.sideColor;
      }

      Offset position = Offset(cNode.x, cNode.y);
      canvas.drawLine(Offset(main.x, main.y), position, paint);
      if(cNode.isAspect == "0")
        addArrow(Offset(main.x, main.y), position, cNode.r, canvas, paint);

    });

  }

  void addArrow(Offset f2, Offset f1, double size, Canvas canvas, Paint paint){
    Path arrow = Path();
      Vector2 vu = Vector2(f1.dx - f2.dx, f1.dy - f2.dy);
    double r = 15;
    double r1 = size - 5;
    double t1 = (vu.length/2 - r)/vu.length;
    double t = (vu.length/2)/vu.length;
    double x0 = (1 - t1)*f1.dx + t1*f2.dx;
    double y0 = (1 - t1)*f1.dy + t1*f2.dy;
    double x = (1 - t)*f1.dx + t*f2.dx;
    double y = (1 - t)*f1.dy + t*f2.dy;
    double x2 = r/2 * cos(-vu.angleToSigned(Vector2(2, 0)) + 90 * (pi / 180.0)) + x;
    double y2 = r/2 * sin(-vu.angleToSigned(Vector2(2, 0)) + 90 * (pi / 180.0)) + y;
    double x3 = r/2 * cos(-vu.angleToSigned(Vector2(2, 0)) - 90 * (pi / 180.0)) + x;
    double y3 = r/2 * sin(-vu.angleToSigned(Vector2(2, 0)) - 90 * (pi / 180.0)) + y;
    arrow.moveTo(x0, y0);
    arrow.lineTo(x2, y2);
    arrow.lineTo(x3, y3);
    arrow.lineTo(x0, y0);
    canvas.drawPath(arrow, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
