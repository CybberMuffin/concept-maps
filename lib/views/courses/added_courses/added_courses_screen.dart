import 'package:concept_maps/models/courses/course.dart';
import 'package:concept_maps/providers/my_courses_provider.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/views/courses/added_courses/course_tree/course_tree.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';

class AddedCoursesScreen extends StatelessWidget {
  const AddedCoursesScreen({Key key}) : super(key: key);

  Widget get appBar => NewGradientAppBar(
        title: Text('My Courses'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        gradient: LinearGradient(colors: [kPurpleColor, kBreezeColor]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: FutureBuilder(
        future: context.read<MyCoursesProvider>().fetchCourses(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<Course> courses = context.read<MyCoursesProvider>().myCourses;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: courses
                    .map<Widget>((course) => ListTile(
                          title: Text(course.caption),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => CourseTree(course: course),
                            ),
                          ),
                        ))
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
