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
  ];

  static Map<String, Color> backgroundColor = {
    'php': Colors.purple,
    'flutter': Colors.blue,
    'dart': Colors.blue[700],
    'angular': Colors.red,
    'react': Colors.blue[400],
    'javascript': Colors.yellow[700],
    'scala': Colors.green,
    'python': Colors.blue[600],
    'html': Colors.orange[600],
    'swift': Colors.orange[400],
  };
}
