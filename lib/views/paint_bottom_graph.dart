import 'package:flutter/cupertino.dart';
import 'package:concept_maps/models/graph_entities/edge.dart';
import 'package:concept_maps/models/graph_entities/vertice.dart';
import 'package:concept_maps/models/graph_entities/node.dart';

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
      if(nodes.firstWhere((a) => a.id == element).isAspect == "1"){
        paint.color = nodes.firstWhere((a) => a.id == element).sideColor;
      }else{
        paint.color = main.sideColor;
      }
      Offset position = Offset(nodes[nodes.indexWhere((a) => a.id == element)].x,
          nodes[nodes.indexWhere((a) => a.id == element)].y);
      canvas.drawLine(Offset(main.x, main.y), position, paint);

    });

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
