import 'package:vector_math/vector_math_64.dart';

class Vertice {
  Vertice(this.id, this.title) : isOn = false;

  var id;
  String title;
  Vector2 position;
  Vector2 displacement;
  Vector2 displacementPrev;
  bool isOn;
}
