import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/material.dart';

class Vertice {
  Vertice(this.id, this.title) : isOn = false, displacementPrev = 1000000.0, isHot = false, hotDistance = 0;

  var id;
  String title;
  String fullTitle;
  Vector2 position;
  Vector2 prevPosition;
  Vector2 displacement;
  Vector2 atr;
  double displacementPrev;
  bool isOn;
  Color mainColor;
  Color sideColor;
  double size;


  bool isHot;
  double hotDistance;
}
