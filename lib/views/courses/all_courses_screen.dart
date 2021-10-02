import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/utils/course_key_list.dart';
import 'package:concept_maps/views/force_directed.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';

class AllCoursesScreen extends StatelessWidget {
  const AllCoursesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text('All Courses'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        gradient: LinearGradient(colors: [kPurpleColor, kBreezeColor]),
      ),
      body: FutureBuilder(
        future: context.read<AppProvider>().fetchAllMaps(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<MapModel> maps = context.read<AppProvider>().maps;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: maps
                    .map<Widget>(
                      (e) => _CourseTile(map: e),
                    )
                    .toList(),
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
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
