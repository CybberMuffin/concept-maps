import 'package:concept_maps/controllers/BalloonTreeController.dart';
import 'package:concept_maps/models/FetchJSON.dart';
import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/services/api_service.dart';
import 'package:flutter/material.dart';
import 'ForceDirected.dart';

class CourseMain extends StatefulWidget {
  @override
  _CourseMainState createState() => _CourseMainState();
}

class _CourseMainState extends State<CourseMain> {
  Future future;
  BalloonTreeController balloonTree;

  @override
  void initState() {
    future = ApiService.fetchConceptRelations("dart");
    future.then((value) {
      setState(() {
        balloonTree = new BalloonTreeController();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget child;
        if (snapshot.hasData) {
          MapModel data = snapshot.data as MapModel;
          child = ForceDirected(data.relations, data.concepts);
          //child = ConceptList(balloonTree.relationToNodes(fetch.relations, fetch.concepts));
        } else {
          print(snapshot.data);
          child = Container();
        }
        return child;
      },
    );
  }
}
