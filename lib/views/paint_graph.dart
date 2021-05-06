import 'package:flutter/cupertino.dart';
import 'package:concept_maps/models/graph_entities/edge.dart';
import 'package:concept_maps/models/graph_entities/vertice.dart';

class PaintGraph extends CustomPainter {
  List<Edge> edges;
  List<Vertice> vertices;

  List<Edge> edgesStart;
  List<Vertice> verticesStart;
  var flag;

  PaintGraph(this.edges, this.vertices, this.flag);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 6
      ..isAntiAlias = true;

    var paint_start = Paint()
      ..color = Color(0xff32f16f)
      ..strokeWidth = 3
      ..isAntiAlias = true;

    /*
    vertices_start.forEach((element) {
      canvas.drawCircle(Offset(element.position.x, element.position.y), 10, paint_start);
    });

    edges_start.forEach((element) {
      canvas.drawLine(Offset(element.v.position.x, element.v.position.y), Offset(element.u.position.x, element.u.position.y), paint_start);
    });

     */
    if (flag) {
      /*
      vertices.forEach((element) {
        canvas.drawCircle(Offset(element.position.x, element.position.y), 10, paint);
      });

       */

      edges.forEach((element) {
        paint.color = element.edgeColor;
        canvas.drawLine(Offset(element.v.position.x, element.v.position.y),
            Offset(element.u.position.x, element.u.position.y), paint);
      });
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
