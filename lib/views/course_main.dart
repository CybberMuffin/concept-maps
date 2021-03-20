import 'package:concept_maps/controllers/balloon_tree_controller.dart';
import 'package:concept_maps/models/fetch_json.dart';
import 'package:concept_maps/views/concept_list.dart';
import 'package:flutter/material.dart';
import 'force_directed.dart';

class CourseMain extends StatefulWidget {
  @override
  _CourseMainState createState() => _CourseMainState();
}

class _CourseMainState extends State<CourseMain> {
  FetchJSON fetch;
  Future future;
  BalloonTreeController balloonTree;

  @override
  void initState() {
    fetch = new FetchJSON("dart");
    future = fetch.parse();
    future.then((value) {
      setState(() {
        balloonTree = BalloonTreeController();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context);

    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = ForceDirected(fetch.relations, fetch.concepts, size);
          //child = ConceptList(
          // balloonTree.relationToNodes(fetch.relations, fetch.concepts));
        } else {
          print(snapshot.data);
          child = Container();
        }
        return child;
      },
    );
  }
}
