import 'package:concept_maps/models/courses/branch.dart';
import 'package:concept_maps/models/courses/course.dart';
import 'package:concept_maps/services/api_service.dart';
import 'package:flutter/material.dart';

class MyCoursesProvider with ChangeNotifier {
  static const userId = '156';
  List<Course> myCourses;

  Future<void> fetchCourses() async {
    myCourses ??= await ApiService.fetchCoursesByUserId(userId);
  }

  Future<void> fetchCourseBranches(Course course) async {
    final index = myCourses.indexOf(course);
    if (myCourses[index].branches?.isEmpty ?? true) {
      final childrenBranches = <Branch>[];
      for (final name in course.nameBranches) {
        childrenBranches.add(await ApiService.fetchBranchChildren(name));
      }

      myCourses[index] = course.copyWith(branches: childrenBranches);
    }
  }

  Course getCourseByName(String name) => myCourses.singleWhere((element) => element.name == name, orElse: () => null);
}
