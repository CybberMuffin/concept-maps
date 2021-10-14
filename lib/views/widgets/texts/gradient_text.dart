import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String data;
  final Gradient gradient;
  final TextStyle style;
  final TextAlign textAlign;
  final int maxLines;
  final bool isDialog;

  GradientText(
    this.data, {
    @required this.gradient,
    this.style,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.isDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(Offset.zero & bounds.size);
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Text(
          data,
          textAlign: textAlign,
          style: style?.copyWith(color: Colors.white) ?? TextStyle(color: Colors.white),
          maxLines: maxLines,
        ),
      ),
    );
  }
}
