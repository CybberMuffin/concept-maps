import 'package:flutter/material.dart';

abstract class CourseListInfo {
  static const List<String> courseKeyList = [
    'php',
    'flutter',
    'dart',
    'angular',
    'react',
    'javascript',
    'scala',
    'python',
    'html',
    'swift',
    'data-science',
    'java',
  ];

  static Map<String, Color> backgroundColor = {
    'php': Colors.purple,
    'flutter': Colors.blue,
    'dart': Colors.red,
    'angular': Colors.blue[700],
    'react': Colors.yellow[700],
    'javascript': Colors.green,
    'scala': Colors.indigoAccent,
    'python': Colors.pink,
    'html': Colors.deepOrange,
    'swift': Colors.amber,
    'data-science': Colors.deepPurpleAccent,
    'java': Colors.blue,
  };
}
