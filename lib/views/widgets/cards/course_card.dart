import 'package:concept_maps/utils/gradient_decorations.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final Decoration decoration;
  final VoidCallback onTap;
  const CourseCard({Key key, @required this.title, this.onTap, @required this.decoration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: 75,
        decoration: decoration,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 3),
          ),
        ),
      ),
    );
  }
}
