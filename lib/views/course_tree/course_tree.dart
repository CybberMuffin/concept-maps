import 'package:concept_maps/models/courses/branch.dart';
import 'package:concept_maps/models/courses/course.dart';
import 'package:concept_maps/providers/my_courses_provider.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/views/course_tree/expandable_branch_tile.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/src/provider.dart';

class CourseTree extends StatelessWidget {
  final Course course;

  const CourseTree({Key key, @required this.course}) : super(key: key);

  Widget get appBar => NewGradientAppBar(
        title: Text(course.caption),
        centerTitle: true,
        automaticallyImplyLeading: false,
        gradient: LinearGradient(colors: [kPurpleColor, kBreezeColor]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: FutureBuilder(
        future: context.read<MyCoursesProvider>().fetchCourseBranches(course),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final courseWithBranches = context.read<MyCoursesProvider>().getCourseByName(course.name);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ListView(
                children:
                    courseWithBranches.branches.map<Widget>((branch) => ExpandableBranchTile(branch: branch)).toList(),
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
