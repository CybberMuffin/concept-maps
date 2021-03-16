import 'package:concept_maps/controllers/BalloonTreeController.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/views/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:concept_maps/views/ListPosition.dart';
import 'package:concept_maps/models/graph_entities/Node.dart';
import 'package:provider/provider.dart';

class ConceptList extends StatefulWidget {
  @override
  _ConceptListState createState() => _ConceptListState();
}

class _ConceptListState extends State<ConceptList> {
  List<Node> tree;
  String title;
  List<String> nodeTitles = [];
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
    final map = context.read<AppProvider>().currentMap;
    tree = BalloonTreeController().relationToNodes(map.relations, map.concepts);
    parseTitle();
    listPositions =
        parseSons(tree[tree.indexWhere((element) => element.parent == -1)]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(title: Text("Concept List")),
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
      ),
    );
  }
}
