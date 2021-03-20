import 'package:concept_maps/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'force_directed.dart';

class CourseMain extends StatefulWidget {
  @override
  _CourseMainState createState() => _CourseMainState();
}

class _CourseMainState extends State<CourseMain> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<AppProvider>().getMapModel('dart').then(
            (_) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ForceDirected(),
              ),
              (_) => false,
            ),
          ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
