import 'package:flutter/material.dart';
import 'package:concept_maps/controllers/ForceDirectedController.dart';
import 'package:concept_maps/views/PaintGraph.dart';
import 'package:zoom_widget/zoom_widget.dart';


class ForceDirected extends StatefulWidget{

  var relations;
  var concepts;

  ForceDirected(this.relations, this.concepts);

  @override
  _ForceDirectedState createState() => _ForceDirectedState(this.relations, this.concepts);
}

class _ForceDirectedState extends State<ForceDirected>{

  _ForceDirectedState(this.relations, this.concepts);

  ForceDirectedController controller;


  var size;
  var relations;
  var concepts;
  var flag;


  void fillWidg(){
    var node_size = 80.0;
    controller.widgets.clear();
    controller.vertices.forEach((element) {

      controller.widgets.add(Positioned(
        top: element.position.y - node_size/2,
        left: element.position.x - node_size/2,
        child: GestureDetector(
          onPanDown: (details){
            element.isOn = true;
          },
          onPanUpdate: (details){
            setState(() {
              //print(details.delta.dx);
              //print("..........................");
              //print(element.position.x);


              controller.forceCalc(size, 1);
              element.position.x+=details.delta.dx;
              element.position.y+=details.delta.dy;
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
          child: Container(
            height: node_size,
            width: node_size,
            decoration: BoxDecoration(
                color: Color(0xffd0efff),
                border: Border.all(color: Color(0xff2a9df4), width: 3),
                borderRadius: BorderRadius.circular(node_size)
            ),
          ),
        ),
      ));
    });
  }



  @override
  void initState() {
    flag = false;
    controller = new ForceDirectedController(relations, concepts);
    controller.crToVE();
    size = Offset(3000,3000);
    controller.setVerticesPos(size);
    controller.forceCalc(size, 500);
    fillWidg();
    flag = true;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
          child: Zoom(
            width: 3000,
            height: 3000,
            centerOnScale: true,
            child: CustomPaint(
              painter: PaintGraph(controller.edges, controller.vertices, flag),
              child: Stack(
                children: controller.widgets,
              ),
            ),
          ),
        )
    );

  }
}
