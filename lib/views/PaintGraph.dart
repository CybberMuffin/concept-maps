import 'package:flutter/cupertino.dart';
import 'file:///C:/Users/vladf/AndroidStudioProjects/simulation_test/lib/Model/Edge.dart';
import 'file:///C:/Users/vladf/AndroidStudioProjects/simulation_test/lib/Model/Vertice.dart';

class PaintGraph extends CustomPainter{

  List<Edge> edges;
  List<Vertice> vertices;

  List<Edge> edges_start;
  List<Vertice> vertices_start;
  var flag;

  PaintGraph(this.edges, this.vertices, this.flag);

  @override
  void paint(Canvas canvas, Size size){
    var paint = Paint()
      ..color = Color(0xff54c5f8)
      ..strokeWidth = 3
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
    if(flag){
      /*
      vertices.forEach((element) {
        canvas.drawCircle(Offset(element.position.x, element.position.y), 10, paint);
      });

       */

      edges.forEach((element) {
        canvas.drawLine(Offset(element.v.position.x, element.v.position.y), Offset(element.u.position.x, element.u.position.y), paint);
      });
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

}