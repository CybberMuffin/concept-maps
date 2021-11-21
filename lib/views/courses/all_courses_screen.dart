import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/providers/user_provider.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/utils/course_key_list.dart';
import 'package:concept_maps/utils/gradient_decorations.dart';
import 'package:concept_maps/views/authorization/login_screen.dart';
import 'package:concept_maps/views/force_directed.dart';
import 'package:concept_maps/views/widgets/cards/course_card.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';

class AllCoursesScreen extends StatelessWidget {
  const AllCoursesScreen({Key key}) : super(key: key);

  Widget appBar(BuildContext context) => NewGradientAppBar(
        title: Text('All Courses'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        gradient: LinearGradient(colors: [kPurpleColor, kBreezeColor]),
        actions: [
          IconButton(onPressed: () => _logOut(context), icon: Icon(Icons.exit_to_app)),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: FutureBuilder(
        future: context.read<AppProvider>().fetchAllMaps(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<MapModel> maps = context.read<AppProvider>().maps;

            return ListView(
              children: maps
                  .map<Widget>(
                    (map) => CourseCard(
                      title: map.field.toUpperCase(),
                      decoration: GradientDecorations.getGradientByIndex().copyWith(boxShadow: [kShadow]),
                      onTap: () => _navigateToMap(context, map),
                    ),
                  )
                  .toList(),
            );
          }

          return Center(child: CircularProgressIndicator(color: kBreezeColor));
        },
      ),
    );
  }

  void _navigateToMap(BuildContext context, MapModel map) {
    final provider = context.read<AppProvider>();
    provider.currentMap = map;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ForceDirected()),
    );
  }

  void _logOut(BuildContext context) {
    context.read<UserProvider>().logOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }
}
