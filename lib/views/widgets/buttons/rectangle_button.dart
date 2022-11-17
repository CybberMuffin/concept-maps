import 'package:flutter/material.dart';

class RectangleButton extends StatelessWidget {
  const RectangleButton({
    Key key,
    @required this.color,
    @required this.onTap,
    @required this.child,
    this.isActive = true,
  }) : super(key: key);

  final Color color;
  final Function onTap;
  final Widget child;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
          color: isActive ? color : Colors.grey.shade500,
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}
