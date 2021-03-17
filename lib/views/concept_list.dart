import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:concept_maps/views/list_position.dart';
import 'package:concept_maps/models/graph_entities/node.dart';

class ConceptList extends StatefulWidget {
  ConceptList(this.tree);

  List<Node> tree;
  // This widget is the root of your application.
  @override
  _ConceptListState createState() => _ConceptListState(this.tree);
}

class _ConceptListState extends State<ConceptList> {
  _ConceptListState(this.tree);

  List<Node> tree;
  String title;
  List<String> nodeTitles = new List<String>();
  Widget listPositions;

  parseSons(Node node) {
    List<Widget> sons = [];
    if (node.child != null) {
      node.child.forEach((a) {
        sons.add(parseSons(tree[tree.indexWhere((i) => i.id == a)]));
      });
    } else {
      sons.add(Container());
    }
    print(sons);
    return ListPosition(title: node.title, sons: sons);
  }

  parseTitle() {
    for (int i = 0; i < tree.length; i++) {
      title = tree[i].title;
      nodeTitles.add(title);
    }
  }

  @override
  void initState() {
    super.initState();
    parseTitle();
    listPositions =
        parseSons(tree[tree.indexWhere((element) => element.parent == -1)]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: 450,
          padding:
              const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
          child: Column(
            children: [
              listPositions,
            ],
          ),
        ),
      ),
    ));
  }
}
