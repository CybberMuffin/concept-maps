import 'package:vector_math/vector_math.dart';

class Vertice {
  Vertice(this.id) : isOn = false;

  var id;
  Vector2 position;
  Vector2 displacement;
  bool isOn;
}
