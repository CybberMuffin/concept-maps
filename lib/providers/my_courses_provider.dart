import 'package:concept_maps/models/courses/course.dart';
import 'package:concept_maps/services/api_service.dart';
import 'package:flutter/material.dart';

class MyCoursesProvider with ChangeNotifier {
  static const userId = '156';
  List<Course> myCourses;

  Future<void> fetchCourses() async {
    myCourses ??= await ApiService.fetchCoursesByUserId(userId);
  }
}
