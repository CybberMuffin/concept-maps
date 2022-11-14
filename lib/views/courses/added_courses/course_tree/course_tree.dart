import 'package:concept_maps/models/courses/course.dart';
import 'package:concept_maps/providers/user_provider.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/views/courses/added_courses/course_tree/expandable_branch_tile.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';

class CourseTree extends StatelessWidget {
  final Course course;

  const CourseTree({Key key, @required this.course}) : super(key: key);

  Widget get appBar => NewGradientAppBar(
        title: Text(course.caption),
        centerTitle: true,
        automaticallyImplyLeading: true,
        gradient: LinearGradient(colors: [kPurpleColor, kBreezeColor]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: FutureBuilder(
        future: context.read<UserProvider>().fetchCourseBranches(course),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final courseWithBranches =
                context.read<UserProvider>().getCourseByName(course.name);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  SizedBox(height: 8),
                  ...courseWithBranches.branches
                      .map<Widget>(
                        (branch) => ExpandableBranchTile(branch: branch),
                      )
                      .toList(),
                ],
              ),
            );
          }

          return Center(child: CircularProgressIndicator(color: kBreezeColor));
        },
      ),
    );
  }
}
