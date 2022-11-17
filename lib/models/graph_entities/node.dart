import 'package:flutter/material.dart';

class Node {
  Node(this.id, this.child, this.parent, this.title,
      [this.mainColor,
      this.sideColor,
      this.defaultMainColor,
      this.defaultSideColor,
      this.d,
      this.isAspect]);

  String id;
  List<String> child;
  List<Node> nodeChild;
  Node nodeParent;
  var parent;
  String title;

  Color mainColor;
  Color sideColor;
  Color defaultMainColor;
  Color defaultSideColor;

  double x, y;
  double r;
  double d;
  double bigR;
  double deg;

  String isAspect;
}
