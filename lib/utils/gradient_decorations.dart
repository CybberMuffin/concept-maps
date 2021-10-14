import 'package:concept_maps/utils/app_colors.dart';
import 'package:flutter/material.dart';

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
}
