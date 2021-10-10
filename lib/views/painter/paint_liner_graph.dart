import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:flutter/cupertino.dart';
import 'package:concept_maps/models/graph_entities/edge.dart';
import 'package:concept_maps/models/graph_entities/vertice.dart';

class PaintLineGraph extends CustomPainter {
  List<Node> linerTree;

  PaintLineGraph(this.linerTree);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xff54c5f8)
      ..strokeWidth = 3
      ..isAntiAlias = true;

    for(int i = 0; i < linerTree.length - 1; i++){
      canvas.drawLine(Offset(linerTree[i].x, linerTree[i].y),
          Offset(linerTree[i+1].x, linerTree[i+1].y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
