import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/views/painter/paint_liner_graph.dart';
import 'package:concept_maps/views/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:provider/provider.dart';
import 'package:concept_maps/views/bottom_panel/bottom_sheet_pannel.dart';
import 'package:concept_maps/models/graph_entities/node.dart';

class LinerGraph extends StatefulWidget {
  @override
  _LinerGraphState createState() => _LinerGraphState();
}

class _LinerGraphState extends State<LinerGraph> with SingleTickerProviderStateMixin {
  List<Node> tree;
  List<Node> linerTree = [];
  List<Widget> titles = [];
  List<Widget> widgets = [];
  Vector2 lastPos;
  List<double> rSizes = [];
  TransformationController transformationController = TransformationController();

  Offset setPosition(Offset startPosition, double displX, double displY) {
    Vector2 position = Vector2(startPosition.dx, startPosition.dy);
    int count = 0;
    double displ = displX;
    for (int i = linerTree.length - 1; i >= 0; i--) {
      linerTree[i].x = position.x;
      linerTree[i].y = position.y;
      position.x += displX;
      position.y += displY;
      print([i, i % 2, displX]);
      displX *= -1;
    }

    // linerTree.forEach((element) {
    //   element.x = position.x;
    //   element.y = position.y;
    //   element.r = 40;
    //   position.x += displX;
    //   position.y -= displY;
    //   displX *= -1;
    // });

    // print(displX);
    // tree[tree.indexWhere((a) => a.id == node.id)].x = position.dx;
    // tree[tree.indexWhere((a) => a.id == node.id)].y = position.dy;
    // Offset nextPos = Offset(position.dx + displX, position.dy + displY);
    // if(node.child != null){
    //   node.child.forEach((element) {
    //     nextPos = setPosition(tree[tree.indexWhere((a) => a.id == element)], nextPos, -displX, displY);
    //   });
    // }
    // return nextPos;
  }

  void fillWidg() {
    widgets.clear();
    titles.clear();
    tree.forEach((element) {
      TextPainter textPainter =
          TextPainter(text: TextSpan(text: element.title), maxLines: 1, textDirection: TextDirection.ltr)
            ..layout(minWidth: 0, maxWidth: double.infinity);
      double textWidth = textPainter.width;

      titles.add(Positioned(
          top: element.y + element.r,
          left: element.x - textWidth * 0.63,
          child: Text(
            element.title,
            //+"\n"+element.displacement.x.toString()+"\n"+element.displacement.y.toString()
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          )));

      widgets.add(Positioned(
        top: element.y - element.r,
        left: element.x - element.r,
        child: GestureDetector(
          onPanDown: (details) {},
          onPanUpdate: (details) {
            setState(() {});
          },
          onPanEnd: (details) {},
          onTap: () {
            setState(() {});
          },
          onDoubleTap: () {
            setState(() {});
          },
          child: Container(
            height: element.r * 2,
            width: element.r * 2,
            decoration: BoxDecoration(
                color: Color(0xffd0efff),
                border: Border.all(color: Color(0xff2a9df4), width: 3),
                borderRadius: BorderRadius.circular(element.r * 2)),
          ),
        ),
      ));
    });
  }

  void updateTree(Node node, int depth) {
    linerTree.add(node);
    linerTree[linerTree.length - 1].r = rSizes[depth];
    if (node.child != null) {
      node.child.forEach((element) {
        depth++;
        updateTree(tree[tree.indexWhere((a) => a.id == element)], depth);
        depth--;
      });
    }
  }

  @override
  void initState() {
    tree = context.read<AppProvider>().tree;
    rSizes = [50, 45, 40, 35, 30, 25, 20, 15, 10, 5];
    updateTree(tree.firstWhere((a) => a.parent == "-1"), 0);
    lastPos = Vector2(0, 0);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final size = MediaQuery.of(context).size;

    setPosition(Offset(size.width * 0.375, size.height * 0.3), size.width * 0.25, size.height * 0.2);

    fillWidg();

    transformationController.value =
        Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, -linerTree[0].y + size.height / 2, 0, 1);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        bottomSheet: BottomSheetPannel(),
        drawer: DrawerMenu(),
        appBar: AppBar(title: Text("Liner Concept Map")),
        body: Container(
            child: InteractiveViewer(
                constrained: false,
                transformationController: transformationController,
                child: Container(
                    width: size.width,
                    height: (linerTree[0].y + size.height / 2).abs(),
                    child: CustomPaint(
                      painter: PaintLineGraph(linerTree),
                      child: Stack(
                        children: [...widgets, ...titles],
                      ),
                    )))));
  }
}
