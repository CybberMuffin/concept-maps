import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/views/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatefulWidget with PreferredSizeWidget {
  final String barTitle;
  final bool isSearchAvailable;

  const SearchAppBar({Key key, @required this.barTitle, this.isSearchAvailable = true}) : super(key: key);

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
    if (widget.isSearchAvailable) {
      tree = context.read<AppProvider>().tree;
      parseTitle();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NewGradientAppBar(
      automaticallyImplyLeading: !widget.isSearchAvailable,
      gradient: LinearGradient(colors: [kPurpleColor, kBreezeColor]),
      actions: <Widget>[
        if (widget.isSearchAvailable)
          IconButton(
            onPressed: () => showSearch(context: context, delegate: Search(nodeTitles, tree)),
            icon: Icon(Icons.search),
          )
      ],
      title: Text(widget.barTitle ?? 'Concept maps'),
    );
  }
}
