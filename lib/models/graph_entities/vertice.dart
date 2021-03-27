import 'package:vector_math/vector_math_64.dart';

class Vertice {
  Vertice(this.id, this.title) : isOn = false, displacementPrev = 1000000.0;

  var id;
  String title;
  Vector2 position;
  Vector2 displacement;
  double displacementPrev;
  bool isOn;
}
