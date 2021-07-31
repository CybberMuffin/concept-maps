import 'package:flutter/cupertino.dart';
import 'package:concept_maps/models/graph_entities/edge.dart';
import 'package:concept_maps/models/graph_entities/vertice.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';

class PaintGraph extends CustomPainter {
  List<Edge> edges;
  List<Vertice> vertices;

  List<Edge> edgesStart;
  List<Vertice> verticesStart;
  var flag;

  PaintGraph(this.edges, this.vertices, this.flag);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 6
      ..isAntiAlias = true;

    Paint paintStart = Paint()
      ..color = Color(0xff32f16f)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke;

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
        if(element.v.isAspect == "0")
          addArrow(element, canvas, paint);
        canvas.drawLine(Offset(element.v.position.x, element.v.position.y),
            Offset(element.u.position.x, element.u.position.y), paint);

      });
    }
  }

  void addArrow(Edge element, Canvas canvas, Paint paint){
    Path arrow = Path();
    Vector2 vu = Vector2(element.v.position.x - element.u.position.x, element.v.position.y - element.u.position.y);
    double r = 40;
    double r1 = element.v.size/2 - 5;
    //double t1 = r1/vu.length;
    double t1 = (vu.length/2 - r/2)/vu.length;
    //double t = (r1 + r)/vu.length;
    double t = (vu.length/2)/vu.length;
    double x0 = (1 - t1)*element.v.position.x + t1*element.u.position.x;
    double y0 = (1 - t1)*element.v.position.y + t1*element.u.position.y;
    double x = (1 - t)*element.v.position.x + t*element.u.position.x;
    double y = (1 - t)*element.v.position.y + t*element.u.position.y;
    double x2 = r/3 * cos(-vu.angleToSigned(Vector2(2, 0)) + 90 * (pi / 180.0)) + x;
    double y2 = r/3 * sin(-vu.angleToSigned(Vector2(2, 0)) + 90 * (pi / 180.0)) + y;
    double x3 = r/3 * cos(-vu.angleToSigned(Vector2(2, 0)) - 90 * (pi / 180.0)) + x;
    double y3 = r/3 * sin(-vu.angleToSigned(Vector2(2, 0)) - 90 * (pi / 180.0)) + y;
    arrow.moveTo(x0, y0);
    arrow.lineTo(x2, y2);
    arrow.lineTo(x3, y3);
    arrow.lineTo(x0, y0);
    canvas.drawPath(arrow, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
