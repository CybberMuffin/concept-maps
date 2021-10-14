import 'package:concept_maps/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SecondaryText extends StatelessWidget {
  final String text;
  final String additionalText;
  final double fontSize;
  final bool primary;
  final bool error;
  final bool requiredToFill;
  final bool small;
  final bool dense;
  final int maxLines;
  final TextAlign textAlign;
  final bool isDialog;
  final Color color;
  final FontWeight fontWeight;

  const SecondaryText(
    this.text, {
    Key key,
    this.primary = false,
    this.fontSize,
    this.error = false,
    this.textAlign,
    this.requiredToFill = false,
    this.small = false,
    this.maxLines,
    this.isDialog = false,
    this.color,
    this.additionalText,
    this.fontWeight,
    this.dense = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Text(
          text + (additionalText ?? '') + (requiredToFill ? "*" : ""),
          style: TextStyle(
            fontSize: small ? 15 : fontSize ?? 18.0,
            fontWeight: fontWeight ?? FontWeight.normal,
            color: color ??
                (error
                    ? Colors.red
                    : primary
                        ? kText
                        : kSecondaryText),
          ),
          textAlign: textAlign ?? TextAlign.center,
          maxLines: maxLines,
        ));
  }
}
