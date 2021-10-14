import 'package:concept_maps/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MainText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final bool small;
  final bool toUpperCase;
  final int maxLines;
  final TextAlign textAlign;

  const MainText(
    this.text, {
    Key key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.toUpperCase = false,
    this.small = false,
    this.maxLines,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Text(
        toUpperCase ? text.toUpperCase() : text,
        style: TextStyle(
          fontSize: fontSize ?? (small ? 19.0 : 21.0),
          fontWeight: fontWeight ?? FontWeight.bold,
          color: color ?? kText,
          letterSpacing: 2,
        ),
        textAlign: textAlign ?? TextAlign.center,
        maxLines: maxLines,
      ),
    );
  }
}
