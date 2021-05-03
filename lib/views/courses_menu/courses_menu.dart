import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/utils/course_key_list.dart';
import 'package:concept_maps/views/force_directed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursesMenu extends StatelessWidget {
  const CoursesMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MapModel> maps = context.read<AppProvider>().maps;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Courses'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: maps
              .map<Widget>(
                (e) => _CourseTile(map: e),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _CourseTile extends StatelessWidget {
  final MapModel map;
  const _CourseTile({Key key, @required this.map}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToMap(context, map),
      child: Container(
        color: CourseListInfo.backgroundColor[map.field],
        child: Center(
          child: Text(
            map.field.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToMap(BuildContext context, MapModel map) {
    final provider = context.read<AppProvider>();
    provider.currentMap = map;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ForceDirected(),
      ),
    );
  }
}
