import 'package:concept_maps/controllers/BalloonTreeController.dart';
import 'package:concept_maps/models/FetchJSON.dart';
import 'package:concept_maps/views/ConceptList.dart';
import 'package:flutter/material.dart';
import 'ForceDirected.dart';

class CourseMain extends StatefulWidget {
  @override
  _CourseMainState createState() => _CourseMainState();
}

class _CourseMainState extends State<CourseMain> {
  FetchJSON fetch;
  Future future;
  BalloonTreeController balloonTree;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: FetchJSON("dart").parse(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget child;
        if (snapshot.hasData) {
          setState(() => balloonTree = BalloonTreeController());
          child = ForceDirected(fetch.relations, fetch.concepts);
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
