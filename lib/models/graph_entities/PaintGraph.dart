import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';
import 'Node.dart';

class PaintGraph extends CustomPainter{

  List<Node> three;
  void Function(List<Node>) addButtons;
  PaintGraph(this.three, this.addButtons);

  void rec_node(Node node, var origin_deg, Canvas canvas, var paint,){

    if(node.child.length > 0){
      for(var j = 0; j < node.child.length; j++){
        for(var i = 0; i < node.child.length - 1; i++){
          if(i < node.child.length/2.floor()){
            if(three[three.indexWhere((a) => a.id == node.child[i])].child.length > three[three.indexWhere((a) => a.id == node.child[i + 1])].child.length){
              var temp = node.child[i];
              node.child[i] = node.child[i + 1];
              node.child[i + 1] = temp;
            }
          }
          else{
            if(three[three.indexWhere((a) => a.id == node.child[i])].child.length < three[three.indexWhere((a) => a.id == node.child[i + 1])].child.length){
              var temp = node.child[i];
              node.child[i] = node.child[i + 1];
              node.child[i + 1] = temp;
            }
          }
        }
      }
    }

    double delta_deg = 45.0;
    double delta_deg_num = (node.child.length - 1)/2.0;
    var deg = origin_deg - delta_deg_num*delta_deg;
    var r;
    //print(node.child.length);

    if(node.child.length > 0){
      node.child.forEach((element) {
        r = 180.0;
        if(three[three.indexWhere((a) => a.id == element)].child.length > 1){
          r = three[three.indexWhere((a) => a.id == element)].child.length*110.0;
        }

        var x = r*Math.cos(deg * (Math.pi / 180.0)) + node.x;
        var y = r*Math.sin(deg * (Math.pi / 180.0)) + node.y;
        canvas.drawCircle(Offset(x, y), 30, paint);
        canvas.drawLine(Offset(node.x, node.y), Offset(x, y), paint);

        three[three.indexWhere((a) => a.id == element)].x = x;
        three[three.indexWhere((a) => a.id == element)].y = y;
        rec_node(three[three.indexWhere((a) => a.id == element)], deg, canvas, paint);
        deg = deg + delta_deg;
        //deg = deg + 360.0/(node.child.length + 1);
      });
    }
    else{
    }

  }

  @override
  void paint(Canvas canvas, Size size){

    var paint = Paint()
      ..color = Color(0xff54c5f8)
      ..strokeWidth = 3
      ..isAntiAlias = true;

    var paint1 = Paint()
      ..color = Color(0xff54c5f8)
      ..strokeWidth = 3
      ..isAntiAlias = true;

    //canvas.drawLine(Offset(111, 111), Offset(300, 300), paint);
    //canvas.drawCircle(Offset(300, 300), 50, paint);
    //canvas.drawLine(Offset(300, 300), Offset(100, 500), paint);
    //canvas.drawCircle(Offset(100, 500), 50, paint);
    var start_point_x = 1500.0;
    var start_point_y = 1500.0;

    three[three.indexWhere((element) => element.parent == -1)].x = start_point_x;
    three[three.indexWhere((element) => element.parent == -1)].y = start_point_y;


    canvas.drawCircle(Offset(start_point_x, start_point_y), 30, paint1);

    var branch = three.where((element) => element.parent == three[three.indexWhere((element) => element.parent == -1)].id);
    var start_deg = 45.0;
    var r = 400.0;
    branch.forEach((element) {
      var x = r*Math.cos(start_deg * (Math.pi / 180.0)) + start_point_x;
      var y = r*Math.sin(start_deg * (Math.pi / 180.0)) + start_point_y;

      canvas.drawCircle(Offset(x, y), 30, paint);
      canvas.drawLine(Offset(start_point_x, start_point_y), Offset(x, y), paint);

      three[three.indexWhere((a) => a.id == element.id)].x = x;
      three[three.indexWhere((a) => a.id == element.id)].y = y;
      rec_node(three[three.indexWhere((a) => a.id == element.id)], start_deg, canvas, paint);

      start_deg = start_deg + 360.0/branch.length.toDouble();
    });

    addButtons(three);
    for(var i = 0; i < branch.length; i++){


    }

    //for(var i = 0; i<three.length;i++){
    //      canvas.drawCircle(Offset(0 + i.toDouble()*220, 0 + i.toDouble()*220), 50, paint);
    //
    //      print(three[i].title);
    //    }


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

}