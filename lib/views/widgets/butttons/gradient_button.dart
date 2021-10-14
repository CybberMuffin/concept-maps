import 'package:concept_maps/views/widgets/texts/main_text.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final BoxDecoration gradientDecorations;
  final String text;
  final Function onPressed;
  final Widget child;
  final double height;
  final double width;
  final Color textColor;

  const GradientButton(
      {Key key,
      this.gradientDecorations,
      this.text,
      this.onPressed,
      this.child,
      this.height,
      this.width,
      this.textColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 56,
      width: width,
      child: RaisedButton(
        padding: EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Ink(
          decoration: gradientDecorations,
          child: Container(
            alignment: Alignment.center,
            child: child ??
                MainText(
                  text,
                  color: textColor,
                  fontSize: 20,
                  toUpperCase: true,
                ),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
