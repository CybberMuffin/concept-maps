import 'package:concept_maps/models/graph_entities/Edge.dart';
import 'package:concept_maps/models/graph_entities/Vertice.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:math';

class ForceDirectedController {
  ForceDirectedController(this.relations, this.concepts);

  var relations;
  var concepts;

  List<Vertice> vertices = [];
  List<Edge> edges = [];
  List<Widget> widgets = [];

  crToVE() {
    concepts.forEach((a) {
      vertices.add(Vertice(a.id));
    });
    relations.forEach((a) {
      edges.add(Edge(vertices[vertices.indexWhere((b) => b.id == a.concept_id)],
          vertices[vertices.indexWhere((b) => b.id == a.to_concept_id)]));
    });
    concepts.forEach((a) {
      if (a.isAspect == "1") {
        edges.add(Edge(vertices[vertices.indexWhere((b) => b.id == a.id)],
            vertices[vertices.indexWhere((b) => b.id == a.aspectOf)]));
      }
    });
  }

  void setVerticesPos(var size) {
    var x;
    var y;
    Random rand = new Random();
    vertices.forEach((element) {
      x = rand.nextInt(size.dx.toInt() - 100);
      y = rand.nextInt(size.dy.toInt() - 100);
      element.position = Vector2(x.toDouble(), y.toDouble());
    });
  }

  double fAttr(var l, var x) {
    return x * x / l;
  }

  double fRep(var l, var x) {
    return l * l / x;
  }

  double euDistance(Vector2 p) {
    return p.x * p.x - p.y * p.y;
  }

  void forceCalc(var size, var iter) {
    //var area = size.width*size.height;
    var area = 900 * 900;
    var force_radius = 500;
    var dis;
    var l = sqrt(area / vertices.length);
    var i = 0;
    Vector2 delta = new Vector2(0, 0);
    while (i < iter) {
      vertices.forEach((v) {
        if (v.isOn == false) {
          v.displacement = new Vector2(0, 0);
          print(v.displacement.x);
          vertices.forEach((u) {
            if (v.id != u.id) {
              dis = sqrt((v.position.x - u.position.x) *
                      (v.position.x - u.position.x) +
                  (v.position.y - u.position.y) *
                      (v.position.y - u.position.y));

              if (dis <= force_radius) {
                delta.x = v.position.x - u.position.x;
                delta.y = v.position.y - u.position.y;

                delta.x = delta.x * fRep(l, delta.length) / delta.length;
                delta.y = delta.y * fRep(l, delta.length) / delta.length;

                v.displacement.x = v.displacement.x + delta.x;
                v.displacement.y = v.displacement.y + delta.y;
              }
            }
          });
        }
      });

      edges.forEach((e) {
        delta.x = e.v.position.x - e.u.position.x;
        delta.y = e.v.position.y - e.u.position.y;

        delta.x = delta.x * fAttr(l, delta.length) / delta.length;
        delta.y = delta.y * fAttr(l, delta.length) / delta.length;

        e.v.displacement.x = e.v.displacement.x - delta.x;
        e.v.displacement.y = e.v.displacement.y - delta.y;

        e.u.displacement.x = e.u.displacement.x + delta.x;
        e.u.displacement.y = e.u.displacement.y + delta.y;
      });

      vertices.forEach((v) {
        if (v.isOn == false) {
          v.position.x = v.position.x +
              v.displacement.x * (iter - i) / v.displacement.length;
          v.position.y = v.position.y +
              v.displacement.y * (iter - i) / v.displacement.length;
          print(v.displacement.length);

          v.position.x = min(size.dx, max(0, v.position.x));
          v.position.y = min(size.dy, max(0, v.position.y));
        }
      });

      i++;
    }
  }
}
