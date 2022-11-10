import 'package:concept_maps/graph_controllers/balloon_tree_controller.dart';
import 'package:concept_maps/models/graph_entities/edge.dart';
import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/models/graph_entities/vertice.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/utils/node_value_list.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';
import 'package:concept_maps/models/graph_entities/node.dart';

class ForceDirectedController {
  ForceDirectedController(this.map);

  MapModel map;

  BalloonTreeController balloon;

  List<Vertice> vertices = [];
  List<Edge> edges = [];
  List<Widget> widgets = [];
  List<Widget> titles = [];
  int rootId;

  crToVE() {
    balloon = BalloonTreeController()..relationToNodes(map);
    rootId = int.parse(balloon.firstId);
    map.concepts.forEach((a) {
      vertices.add(Vertice(a.id, a.concept, a.isAspect, a.forms));
    });
    map.relations.forEach((a) {
      edges.add(Edge(vertices[vertices.indexWhere((b) => b.id == a.conceptId)],
          vertices[vertices.indexWhere((b) => b.id == a.toConceptId)]));
    });
    map.concepts.forEach((a) {
      if (a.isAspect == "1") {
        vertices.firstWhere((element) => element.id == a.id).fullTitle =
            vertices.firstWhere((element) => element.id == a.aspectOf).title +
                ": " +
                a.concept;
        edges.add(Edge(vertices[vertices.indexWhere((b) => b.id == a.id)],
            vertices[vertices.indexWhere((b) => b.id == a.aspectOf)]));
      } else {
        vertices.firstWhere((element) => element.id == a.id).fullTitle =
            a.concept;
      }
    });
  }

  void nodeRecursion(Node node, double originDeg, List<Node> three) {
    if (node.child.length > 0) {
      for (var j = 0; j < node.child.length; j++) {
        for (var i = 0; i < node.child.length - 1; i++) {
          if (i < node.child.length / 2.floor()) {
            if (three[three.indexWhere((a) => a.id == node.child[i])]
                    .child
                    .length >
                three[three.indexWhere((a) => a.id == node.child[i + 1])]
                    .child
                    .length) {
              String temp = node.child[i];
              node.child[i] = node.child[i + 1];
              node.child[i + 1] = temp;
            }
          } else {
            if (three[three.indexWhere((a) => a.id == node.child[i])]
                    .child
                    .length <
                three[three.indexWhere((a) => a.id == node.child[i + 1])]
                    .child
                    .length) {
              var temp = node.child[i];
              node.child[i] = node.child[i + 1];
              node.child[i + 1] = temp;
            }
          }
        }
      }
    }

    double deltaDeg = 15.0;
    double deltaDegNum = (node.child.length - 1) / 2.0;
    double deg = originDeg - deltaDegNum * deltaDeg;
    double r;
    //print(node.child.length);

    if (node.child.length > 0) {
      node.child.forEach((element) {
        //r = balloon.three.firstWhere((a) => a.id == element).child.length*75.0+200;
        r = 200;
        double x = r * cos(deg * (pi / 180.0)) + node.x;
        double y = r * sin(deg * (pi / 180.0)) + node.y;
        three[three.indexWhere((a) => a.id == element)].x = x;
        three[three.indexWhere((a) => a.id == element)].y = y;
        //print([x, y]);
        nodeRecursion(
            three[three.indexWhere((a) => a.id == element)], deg, three);
        deg = deg + deltaDeg;
      });
    } else {}
  }

  bool wasConceptViewed(List<String> viewedConceptIds, String conceptId) {
    bool wasViewed = false;
    for (int i = 0; i < viewedConceptIds.length; i++) {
      if (viewedConceptIds[i] == conceptId && !wasViewed) {
        wasViewed = true;
      }
    }
    return wasViewed;
  }

  void setVerticesEdgesColors(List<Node> tree, List<String> viewedConceptIds) {
    vertices.forEach((a) {
      bool wasViewed = wasConceptViewed(viewedConceptIds, a.id);
      int treeIndex = tree.indexWhere((element) => element.id == a.id);
      a.mainColor =
          wasViewed ? kWasViewedConceptColor : tree[treeIndex].mainColor;
      a.sideColor =
          wasViewed ? kWasViewedConceptSideColor : tree[treeIndex].sideColor;
      a.size = tree[treeIndex].d;
    });

    edges.forEach((a) {
      if (a.v.mainColor == NodeValueList.color[0][0] ||
          a.u.mainColor == NodeValueList.color[0][0]) {
        a.edgeColor = NodeValueList.color[0][1];
      } else {
        a.edgeColor =
            tree.firstWhere((element) => element.id == a.u.id).sideColor;
      }
    });
  }

  void setVerticesPos(Offset size) {
    int x;
    int y;
    Random rand = new Random();
    balloon.three[balloon.three.indexWhere((element) => element.parent == "-1")]
        .x = size.dx / 2;
    balloon.three[balloon.three.indexWhere((element) => element.parent == "-1")]
        .y = size.dy / 2;
    List<Node> branch = balloon.three
        .where((element) =>
            element.parent ==
            balloon
                .three[balloon.three
                    .indexWhere((element) => element.parent == "-1")]
                .id)
        .toList();
    double startDeg = 45.0;
    branch.forEach((element) {
      //double r = element.child.length*100.0 + 200;
      double r = 200;
      double x = r * cos(startDeg * (pi / 180.0)) + size.dx / 2;
      double y = r * sin(startDeg * (pi / 180.0)) + size.dy / 2;
      balloon.three[balloon.three.indexWhere((a) => a.id == element.id)].x = x;
      balloon.three[balloon.three.indexWhere((a) => a.id == element.id)].y = y;

      nodeRecursion(
          balloon.three[balloon.three.indexWhere((a) => a.id == element.id)],
          startDeg,
          balloon.three);
      startDeg = startDeg + 360.0 / branch.length.toDouble();
    });
    balloon.three.forEach((element) {
      // print(element.id);
      // print(vertices[vertices.indexWhere((a) => a.id == element.id)].id);
      // print(element.x);
      // print(element.x.runtimeType);
      // print(element.y);
      // print(element.y.runtimeType);
      // print("_________________________");
      vertices[vertices.indexWhere((a) => a.id == element.id)].position =
          Vector2(element.x, element.y);
    });

    /*
    vertices.forEach((element) {
      x = rand.nextInt(size.dx.toInt() - 100);
      y = rand.nextInt(size.dy.toInt() - 100);
      element.position = Vector2(x.toDouble(), y.toDouble());
    });

     */
  }

  double fAttr(var l, var x) {
    return x * x / l;
  }

  double fRep(var l, var x) {
    return l * l / x;
  }

  double fEdgeRep(var l, var x) {
    return l * l / x;
  }

  double euDistance(Vector2 p) {
    return p.x * p.x - p.y * p.y;
  }

  Duration forceCalc(var size, var iter, double force) {
    //var area = size.width*size.height;
    Stopwatch st = Stopwatch()..start();
    var side = 30 * vertices.length;
    var area = side * side;
    var l = sqrt(area / vertices.length);
    double forceRadius = 300.0;
    var dis;
    var i = 0;
    bool isSat = true;
    double hotDisp = 100;
    double t = side / 2;
    Vector2 delta = Vector2(0, 0);
    double avX = 0;
    double avY = 0;
    double maxDisp = 1500.0;
    int satCount = 0;
    while (i < iter) {
      vertices.forEach((v) {
        if (v.isOn == false) {
          v.displacement = Vector2(0, 0);

          //vertices repulsion force
          vertices.forEach((u) {
            if (v.id != u.id) {
              if (v.position.x == u.position.x) {
                v.position.x++;
              }

              dis = sqrt((v.position.x - u.position.x) *
                      (v.position.x - u.position.x) +
                  (v.position.y - u.position.y) *
                      (v.position.y - u.position.y));
              if (dis <= forceRadius) {
                if (dis < hotDisp) {
                  v.isHot = true;
                  v.hotDistance = forceRadius;
                }
                delta.x = v.position.x - u.position.x;
                delta.y = v.position.y - u.position.y;

                delta.x = delta.x * fRep(l, delta.length) / delta.length;
                delta.y = delta.y * fRep(l, delta.length) / delta.length;

                v.displacement.x = v.displacement.x + delta.x;
                v.displacement.y = v.displacement.y + delta.y;
              }
            }
          });

          //edges repulsion force
          edges.forEach((element) {
            if (element.u.id != v.id && element.v.id != v.id) {
              double halfX = (element.u.position.x + element.v.position.x) / 2;
              double halfY = (element.u.position.y + element.v.position.y) / 2;
              dis = sqrt((v.position.x - halfX) * (v.position.x - halfX) +
                  (v.position.y - halfY) * (v.position.y - halfY));
              //double a = (element.v.position.y - element.u.position.y);
              //double b = - (element.v.position.x - element.u.position.x);
              //double c = element.u.position.y*(element.v.position.x - element.u.position.x) - element.u.position.x*(element.v.position.y - element.u.position.y);
              //dis = (a*v.position.x +  b*v.position.x + c).abs()/sqrt(pow(a, 2) + pow(b, 2));
              if (dis <= forceRadius) {
                if (dis < hotDisp) {
                  v.isHot = true;
                  v.hotDistance = forceRadius;
                }
                //double x = (b*(b*v.position.x - a*v.position.y) - a*c)/(a*a + b*b);
                //double y = (a*(-b*v.position.x + a*v.position.y) - b*c)/(a*a + b*b);
                //if(inRange(element.v.position.x, element.u.position.x, x) && inRange(element.v.position.y, element.u.position.y, y)){

                //delta.x = v.position.x - x;
                //delta.y = v.position.y - y;
                delta.x = v.position.x - halfX;
                delta.y = v.position.y - halfY;

                if (delta.length == 0) {
                  delta.x++;
                }

                delta.x = delta.x * fRep(l, delta.length) / delta.length;
                delta.y = delta.y * fRep(l, delta.length) / delta.length;

                v.displacement.x = v.displacement.x + delta.x;
                v.displacement.y = v.displacement.y + delta.y;
                //}
              }
            }
          });
        }
      });

      //vertices attraction force
      edges.forEach((e) {
        delta.x = e.v.position.x - e.u.position.x;
        delta.y = e.v.position.y - e.u.position.y;

        delta.x = delta.x * fAttr(l, delta.length) / delta.length;
        delta.y = delta.y * fAttr(l, delta.length) / delta.length;

        e.v.displacement.x = e.v.displacement.x - delta.x;
        e.v.displacement.y = e.v.displacement.y - delta.y;

        e.u.displacement.x = e.u.displacement.x + delta.x;
        e.u.displacement.y = e.u.displacement.y + delta.y;

        e.u.atr = Vector2(delta.x, delta.y);
        e.v.atr = Vector2(delta.x, delta.y);
      });

      vertices.forEach((v) {
        if (v.isOn == false) {
          double d =
              test3(iter, i, forceRadius, l, v.isHot, v.hotDistance, force);
          v.isHot = false;
          v.hotDistance -= forceRadius / ((iter - i) / 100);
          v.position.x = v.position.x +
              v.displacement.x *
                  test3(iter, i, forceRadius, l, v.isHot, v.hotDistance,
                      v.displacement.x) /
                  v.displacement.length;
          v.position.y = v.position.y +
              v.displacement.y *
                  test3(iter, i, forceRadius, l, v.isHot, v.hotDistance,
                      v.displacement.y) /
                  v.displacement.length;

          v.displacementPrev = v.displacement.length;
          v.position.x = min(size.dx, max(0, v.position.x));
          v.position.y = min(size.dy, max(0, v.position.y));

          v.prevPosition = Vector2(v.position.x, v.position.y);

          avX = v.displacement.x;
          avY = v.displacement.y;
          if ((avX <= maxDisp && avX >= -maxDisp) &&
              (avY <= maxDisp && avY >= -maxDisp)) {
            satCount++;
          }
        }
        t = test(size, iter, i);
      });
      i++;
      if (satCount >= vertices.length) {
        isSat = false;
      }

      if (i >= 1000) {
        isSat = false;
      }
      satCount = 0;
    }
    return st.elapsed;
  }

  bool inRange(double x1, double x2, double x3) {
    //print(x1);
    //print(x2);
    //print(x3);
    //print("-----------");
    if (x1 > x2) {
      if (x3 >= x2 && x3 <= x1) {
        return true;
      } else {
        return false;
      }
    } else if (x1 <= x2) {
      if (x3 >= x1 && x3 <= x2) {
        return true;
      } else {
        return false;
      }
    }
  }

  double test3(int iter, int i, double rad, double l, bool isHot,
      double hotDistance, double force) {
    Random rand = Random();
    int r = rand.nextInt(i + 1);
    if (iter == 1) {
      if (force < 500 && force > -500) {
        return 5;
      } else if (force < 1000 && force > -1000) {
        return 45;
      } else if (force < 2000 && force > -2000) {
        return 65;
      } else if (force < 5000 && force > -5000) {
        return 110;
      } else if (force < 10000 && force > -10000) {
        return 190;
      } else {
        return 250;
      }
    } else if (isHot) {
      return hotDistance / (i + 1);
    } else {
      return rad - (rad / iter) * i;
      //return rad - (rad/force) + 5;
    }
  }

  double test2(Offset size, double displacement, double displacementPrev,
      int iMax, int i, double t) {
    if (displacement > displacementPrev) {
      double e = exp(-displacement / t);
      Random rand = Random();
      int r = rand.nextInt(1);
      if (r <= e) {
        return test(size, iMax, i) + test(size, iMax, i);
      } else {
        return test(size, iMax, i);
      }
    } else {
      return test(size, iMax, i);
    }
  }

  double test(Offset size, int iMax, int i) {
    return size.dx / 2 - (size.dx * (i + 1)) / (2 * iMax) + 1;
  }

  double temperature(
      double displacement, double i, int iMax, double frameWidth) {
    double value = frameWidth / 2;
    if (displacement < value) {
      value = displacement;
    }

    i /= iMax / 2;
    if (i < 1) {
      return -value / 2 * i * i * i * i * i + value;
    }
    i -= 2;
    return -value / 2 * (i * i * i * i * i + 2) + value;
  }
}
