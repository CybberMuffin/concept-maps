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
      @required this.text,
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
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
            return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30));
          }),
          padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>((_) {
            return EdgeInsets.zero;
          }),
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
