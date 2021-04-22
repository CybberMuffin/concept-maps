import 'package:concept_maps/controllers/balloon_tree_controller.dart';
import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/views/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  _SearchAppBarState createState() => _SearchAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  List<Node> tree;
  String title;
  List<String> nodeTitles = [];

  parseTitle() {
    for (int i = 0; i < tree.length; i++) {
      title = tree[i].title;
      nodeTitles.add(title);
    }
  }

  @override
  void initState() {
    final map = context.read<AppProvider>().currentMap;
    tree = BalloonTreeController().relationToNodes(map.relations, map.concepts);
    parseTitle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          onPressed: () {
            showSearch(context: context, delegate: Search(nodeTitles, tree));
          },
          icon: Icon(Icons.search),
        )
      ],
      title: Text('Concept maps'),
    );
  }
}
