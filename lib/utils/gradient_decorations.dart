import 'package:concept_maps/utils/app_colors.dart';
import 'package:flutter/material.dart';

var kShadow = BoxShadow(
  color: Colors.grey.withOpacity(0.4),
  blurRadius: 25.0,
  spreadRadius: 5.0,
  offset: Offset(15.0, 15.0),
);

class GradientDecorations {
  static LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [kBreezeColor, kPurpleColor],
  );

  static LinearGradient mainGradientReversed = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [kBreezeColor, kPurpleColor],
  );

  static LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [kBreezeColor, kGreyBlueColor],
  );

  static BoxDecoration mainGradientDecoration = BoxDecoration(
    gradient: mainGradient,
    borderRadius: BorderRadius.circular(10.0),
  );

  static BoxDecoration secondaryGradientDecoration = BoxDecoration(
    gradient: secondaryGradient,
    borderRadius: BorderRadius.circular(10.0),
  );

  static BoxDecoration getGradientByIndex({int level = 1}) {
    //for one color gradient
    final gradient = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [levelColors[level % 3], levelColors[(level + 1) % 3]],
    );
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}
