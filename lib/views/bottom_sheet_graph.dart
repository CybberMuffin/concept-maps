import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'dart:math';
import 'package:concept_maps/views/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/controllers/force_directed_controller.dart';
import 'package:concept_maps/views/paint_graph.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/physics.dart';
import 'package:provider/provider.dart';
import 'package:concept_maps/views/paint_bottom_graph.dart';

class BottomSheetGraph extends StatefulWidget {

  @override
  _BottomSheetGraphState createState() => _BottomSheetGraphState();
}

class _BottomSheetGraphState extends State<BottomSheetGraph>
    with SingleTickerProviderStateMixin {

  Node node;
  List<Node> newNodes = [];
  MapModel map;
  List<Widget> widgets = [];

  void addWidget(Node node){
    TextPainter textPainter = TextPainter(
        text: TextSpan(text: node.title),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    double textWidth = textPainter.width;
    print(textWidth);
    print(node.x);

    widgets.add(Positioned(
        top: node.y + node.r,
        left: node.x - textWidth*0.63,
        child: Text(
          node.title,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        )));

    widgets.add(Positioned(
      top: node.y - node.r,
      left: node.x - node.r,
      child: GestureDetector(
        onTap: () {
          setState(() {
            //runAnimation(Offset(element.position.x, element.position.y));
            //context.read<AppProvider>().setFocusNode(controller.balloon
            //    .three[controller.balloon.three.indexWhere((a) => a.id == element.id)]);
          });
        },
        child: Container(
          height: 2*node.r,
          width: 2*node.r,
          decoration: BoxDecoration(
              color: Color(0xffd0efff),
              border: Border.all(color: Color(0xff2a9df4), width: 3),
              borderRadius: BorderRadius.circular(2*node.r)),
        ),
      ),
    ));
  }

  void setPosition(){
    widgets.clear();
    newNodes.clear();
    final size = MediaQuery.of(context).size;
    double deltaDeg = 40.0;
    double deltaDegNum = (node.child.length - 1)/2.0;
    double deg = deltaDegNum*deltaDeg - 90;
    double circleR = (size.height*0.4 - 45)/10;
    double r = circleR*5;
    newNodes.add(Node(node.id, [], "-1", node.title));
    newNodes[0].x = size.width/2 - 15;
    newNodes[0].y = size.height*0.4 - 40 - circleR*4;
    newNodes[0].r = circleR;
    addWidget(newNodes[0]);
    node.child.forEach((element) {
      newNodes.add(Node(
          element,
          [],
          node.id,
          map.concepts[map.concepts.indexWhere((a) => a.id == element)].
          concept)
      );
      newNodes[0].child.add(element);
      double x = r*cos(deg * (pi / 180.0)) + newNodes[0].x;
      double y = r*sin(deg * (pi / 180.0)) + newNodes[0].y;
      newNodes[newNodes.length - 1].x = x;
      newNodes[newNodes.length - 1].y = y;
      newNodes[newNodes.length - 1].r = circleR;
      addWidget(newNodes[newNodes.length - 1]);
      deg -= deltaDeg;
    });


  }

  @override
  void initState() {
    map = context.read<AppProvider>().currentMap;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    node = Provider.of<AppProvider>(context, listen: true).focusNode;
    setPosition();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<AppProvider>(builder: (context, value, _) => Container(
      color: Color(0xfffa9df4),
      width: size.width - 30,
      height: size.height*0.4,
      child: CustomPaint(
        painter: PaintBottomGraph(newNodes, value.focusNode),
        child: Stack(
          children: widgets,
        ),
      ),
    ));
  }
}
