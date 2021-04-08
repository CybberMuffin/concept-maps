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
  Animation<Offset> animation;

  AnimationController animationController;


  void runAnimation(Offset position) {
    final size = MediaQuery.of(context).size;
    //Matrix4 matrix = Matrix4.copy(transformationController.value);
    //matrix.row0 = Vector4(scale, 0, 0, -position.dx*scale + size.width / 2);
    //matrix.row1 = Vector4(0, scale, 0, -position.dy*scale + size.height*0.25);
    //matrix.row2 = Vector4(0, 0, scale, 0);
    //matrix.row3 = Vector4(position.dx, position.dy, 0, 1);

    //animation = animationController.drive(
    //    Matrix4Tween(begin: transformationController.value, end: matrix));

    /*
    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -5);

    animationController.animateWith(simulation);
    */
  }

  void addWidget(Node node){
    TextPainter textPainter = TextPainter(
        text: TextSpan(text: node.id),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    double textWidth = textPainter.width;

    widgets.add(Positioned(
        top: node.y + node.r,
        left: node.x - textWidth*0.63,
        child: Text(
          node.id,
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
            Provider.of<AppProvider>(context, listen: false).setAnimationParam(node.id);
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

  void addBorderWidget(Node node){
    widgets.add(Positioned(
      top: node.y,
      child: GestureDetector(
        onTap: () {
          Provider.of<AppProvider>(context, listen: false).setAnimationParam(node.id);
        },
        child: Container(
          height: 4*node.r,
          width: node.x*2,
          decoration: BoxDecoration(
              color: Color(0xffffffff)
          ),
        ),
      ),
    ));
  }

  void addBackWidget(Node node){

    widgets.add(Positioned(
      top: node.y - node.r,
      left: node.x - node.r,
      child: Container(
        height: 2*node.r,
        width: 2*node.r,
        //color: Color(0xff2f0df4),
        child: IconButton(
          onPressed: () {
            Provider.of<AppProvider>(context, listen: false).setAnimationParam(node.id);
          },
          icon: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 50,
            color: Color(0xff2a9df4),
          ),
        ),
      ),
    ));
  }

  void removeAndAddNode(Node removeNode, String nextId, int index, double startDeg){
    newNodes.remove(removeNode);

    if(startDeg == -180.0){
      newNodes.insert(index, Node(
          nextId,
          [],
          node.id,
          map.concepts[map.concepts.indexWhere((a) => a.id == nextId)].
          concept)
      );
    }
    else if(startDeg == 0){
      newNodes.add(Node(
          nextId,
          [],
          node.id,
          map.concepts[map.concepts.indexWhere((a) => a.id == nextId)].
          concept)
      );
    }

    newNodes[0].child.add(nextId);
    newNodes[0].child.remove(removeNode.id);
    double x = removeNode.bigR*cos(startDeg * (pi / 180.0)) + newNodes[0].x;
    double y = removeNode.bigR*sin(startDeg * (pi / 180.0)) + newNodes[0].y;
    newNodes[index].x = x;
    newNodes[index].y = y;
    newNodes[index].deg = startDeg;
    newNodes[index].r = removeNode.r;
    newNodes[index].bigR = removeNode.bigR;
    //newNodes.length - 1
  }
  void resetPosition(Offset offset){
    widgets.clear();
    Node n1, n2;
    String nextId;
    bool isRemoved = false;
    Node removeNode;
    double newDeg;
    int index;
    newNodes.forEach((element) {
      if(element.parent != "-1" && element.parent != "-2"){
        double displ = offset.dx.sign*sqrt(pow(offset.dx, 2) + pow(offset.dy, 2));
        element.x = element.bigR*cos((element.deg + displ) * (pi / 180.0)) + newNodes[0].x;
        element.y = element.bigR*sin((element.deg + displ) * (pi / 180.0)) + newNodes[0].y;
        element.deg = element.deg + displ;
        double a = asin(element.r/element.bigR)*(180.0/pi);
        if(element.deg <= - 181.0 - a){

          int nextIndex = node.child.indexWhere((a) => a == element.id) + 4;
          if(nextIndex > node.child.length - 1){
            nextIndex = 3 - (node.child.length - 1 - (nextIndex - 4));
          }
          nextId = node.child[nextIndex];
          index = newNodes.length - 1;
          newDeg = 0.0;
          removeNode = element;

        }
        else if(element.deg >= a + 1){
          int prevIndex = node.child.indexWhere((a) => a == element.id) - 4;
          if(prevIndex < 0){
            prevIndex = node.child.length + prevIndex;
          }
          nextId = node.child[prevIndex];
          index = 2;
          newDeg = -180.0;
          removeNode = element;

        }
      }
      if(element.parent != "-2" && element.parent != "-1"){
        addWidget(element);
      }
      else if(element.parent == "-1"){
        n1 = element;
      }
      else if(element.parent == "-2"){
        n2 = element;
      }
    });

    if(removeNode != null){
      removeAndAddNode(removeNode, nextId, index, newDeg);
    }
    addBorderWidget(n1);
    addWidget(n1);
    if(n2 != null) {
      addBackWidget(n2);
    }
  }

  void setPosition(){
    widgets.clear();
    newNodes.clear();
    final size = MediaQuery.of(context).size;
    double deltaDeg = -45.0;
    int c = (node.child.length > 4)? 4 : node.child.length;
    double deltaDegNum = (c - 1)/2.0;
    double deg = deltaDegNum*deltaDeg - 90;
    double circleR = (size.height*0.4 - 45)/10;
    double r = circleR*5.5;
    newNodes.add(Node(node.id, [], "-1", node.title));
    newNodes[0].x = size.width/2 - 15;
    newNodes[0].y = size.height*0.4 - 40 - circleR*3.5;
    newNodes[0].r = circleR;
    if(node.parent != "-1") {
      newNodes.add(Node(node.parent, [node.id], "-2", ""));
      newNodes[1].x = size.width/2 - 15;
      newNodes[1].y = size.height*0.4 - 40 - circleR*0.5;
      newNodes[1].r = circleR;
      addBackWidget(newNodes[1]);
    }
    int i = 0;
    while(i < node.child.length){
      newNodes.add(Node(
          node.child[i],
          [],
          node.id,
          map.concepts[map.concepts.indexWhere((a) => a.id == node.child[i])].
          concept)
      );
      newNodes[0].child.add(node.child[i]);
      double x = r*cos(deg * (pi / 180.0)) + newNodes[0].x;
      double y = r*sin(deg * (pi / 180.0)) + newNodes[0].y;
      newNodes[newNodes.length - 1].x = x;
      newNodes[newNodes.length - 1].y = y;
      newNodes[newNodes.length - 1].deg = deg;
      newNodes[newNodes.length - 1].r = circleR;
      newNodes[newNodes.length - 1].bigR = r;
      addWidget(newNodes[newNodes.length - 1]);
      deg -= deltaDeg;

      i++;
      if(i == 4){
        break;
      }
    }
    addBorderWidget(newNodes[0]);
    addWidget(newNodes[0]);
    if(node.parent != "-1") {
      addBackWidget(newNodes[1]);
    }
  }

  @override
  void initState() {

    animationController =
        AnimationController(duration: Duration(microseconds: 200), vsync: this)
    ..addListener(() {
      setState(() {
      });
    });

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
    return Consumer<AppProvider>(builder: (context, value, _) => GestureDetector(
        onPanDown: (details) {

        },
        onPanUpdate: (details) {
          setState(() {
            resetPosition(details.delta);
          });
        },
        onPanEnd: (details) {

        },
        child: Container(
            width: size.width - 30,
            height: size.height*0.4,
            //color: Color(0xffd04fff),
            child: CustomPaint(
                painter: PaintBottomGraph(newNodes, value.focusNode),
                child: Stack(
                  children: widgets,
                )
            )
        )
    )
    );
  }
}
