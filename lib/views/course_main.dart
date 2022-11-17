import 'package:concept_maps/views/courses/all_courses_screen.dart';
import 'package:concept_maps/views/courses/added_courses/added_courses_screen.dart';
import 'package:concept_maps/views/statistics/statistics_screen.dart';
import 'package:flutter/material.dart';

class CourseMain extends StatefulWidget {
  @override
  _CourseMainState createState() => _CourseMainState();
}

class _CourseMainState extends State<CourseMain> {
  int _currentTabIndex = 0;

  final _menuItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.my_library_books_outlined), label: 'My Courses'),
    BottomNavigationBarItem(
        icon: Icon(Icons.list_alt_outlined), label: 'All Courses'),
  ];

  Widget get _currentTab {
    switch (_currentTabIndex) {
      case 0:
        return AddedCoursesScreen();
      case 1:
        return AllCoursesScreen();
      default:
        return AddedCoursesScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentTab,
      bottomNavigationBar: BottomNavigationBar(
        items: _menuItems,
        currentIndex: _currentTabIndex,
        onTap: (index) => setState(() => _currentTabIndex = index),
      ),
    );
  }
}
