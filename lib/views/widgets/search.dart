import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context));
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    Navigator.pop(context);
    Provider.of<AppProvider>(context, listen: false).setAnimationParam(
        tree.firstWhere((element) => element.title == selectedResult).id);
    return Container();
  }

  List<String> listExample;
  List<Node> tree;
  Search(this.listExample, this.tree);

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    query.isEmpty
        ? suggestionList =
            context.read<AppProvider>().recentList //In the true case
        : suggestionList.addAll(listExample.where(
            // In the false case
            (element) => element.toLowerCase().contains(query),
          ));

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: () {
            selectedResult = suggestionList[index];
            buildResults(context);
            if (context.read<AppProvider>().recentList.length < 10) {
              context
                  .read<AppProvider>()
                  .addSearchHistory(suggestionList[index]);
            } else {
              context.read<AppProvider>().removeSearchHistory();
              context
                  .read<AppProvider>()
                  .addSearchHistory(suggestionList[index]);
            }
          },
        );
      },
    );
  }
}
