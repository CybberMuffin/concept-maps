import 'package:concept_maps/constants/general.dart';
import 'package:concept_maps/models/courses/course.dart';
import 'package:concept_maps/providers/user_provider.dart';
import 'package:concept_maps/services/auth_service.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/utils/gradient_decorations.dart';
import 'package:concept_maps/views/authorization/login_screen.dart';
import 'package:concept_maps/views/courses/added_courses/course_tree/course_tree.dart';
import 'package:concept_maps/views/widgets/cards/course_card.dart';
import 'package:concept_maps/views/widgets/texts/main_text.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';

class AddedCoursesScreen extends StatelessWidget {
  const AddedCoursesScreen({Key key}) : super(key: key);

  Widget appBar(BuildContext context) => NewGradientAppBar(
        title: Text('My Courses'),
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
        future: context.read<UserProvider>().fetchCourses(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final List<Course> courses = context.read<UserProvider>().myCourses;
            if (courses?.isEmpty ?? true) {
              return Center(child: MainText('No Added Courses Yet'));
            }

            return ListView(
              children: courses
                  .map<Widget>(
                    (course) => CourseCard(
                      title: course.caption.toUpperCase(),
                      decoration: GradientDecorations.getGradientByIndex(courses.indexOf(course))
                          .copyWith(boxShadow: [kShadow]),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CourseTree(course: course)),
                      ),
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

  void _logOut(BuildContext context) {
    context.read<UserProvider>().logOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }
}
