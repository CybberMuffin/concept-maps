import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  List<bool> dots;
  double width;
  List<Widget> widgets = [];
  DotsIndicator(this.dots);

  void addWidgets() {
    width = 0;
    double circleSize = 6;
    dots.forEach((element) {
      if (element) {
        widgets.add(Container(
          margin: const EdgeInsets.only(left: 2, right: 2),
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.circular(20)),
        ));
      } else {
        widgets.add(Container(
          margin: const EdgeInsets.only(left: 2, right: 2),
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(20)),
        ));
      }
      width += circleSize + 4;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    addWidgets();
    return Container(
        width: size.width - 30,
        height: 6,
        alignment: Alignment.center,
        child: Container(
          width: width,
          height: 6,
          child: Row(
            children: widgets,
          ),
        ));
  }
}
