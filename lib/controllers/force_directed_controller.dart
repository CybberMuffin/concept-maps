import 'package:concept_maps/controllers/balloon_tree_controller.dart';
import 'package:concept_maps/models/graph_entities/edge.dart';
import 'package:concept_maps/models/graph_entities/vertice.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';
import 'package:concept_maps/models/graph_entities/node.dart';

class ForceDirectedController{

  ForceDirectedController(this.relations, this.concepts);

  var relations;
  var concepts;

  BalloonTreeController balloon;

  List<Vertice> vertices = [];
  List<Edge> edges = [];
  List<Widget> widgets = [];
  List<Widget> titles = [];
  int rootId;



  crToVE(){
    int n = 10000000000;
    concepts.forEach((a) {
      if(int.parse(a.id) < n){
        n = int.parse(a.id);
        rootId = n;
      }

      vertices.add(Vertice(a.id, a.concept));
    });
    relations.forEach((a) {
      edges.add(Edge(vertices[vertices.indexWhere((b) => b.id == a.concept_id)], vertices[vertices.indexWhere((b) => b.id == a.to_concept_id)]));
    });
    concepts.forEach((a) {
      if(a.isAspect == "1"){
        edges.add(Edge(vertices[vertices.indexWhere((b) => b.id == a.id)], vertices[vertices.indexWhere((b) => b.id == a.aspectOf)]));
      }
    });
  }

  void nodeRecursion(Node node, double originDeg, List<Node> three) {
    if (node.child.length > 0) {
      for (var j = 0; j < node.child.length; j++) {
        for (var i = 0; i < node.child.length - 1; i++) {
          if (i < node.child.length / 2.floor()) {
            if (three[three.indexWhere((a) => a.id == node.child[i])].child
                .length >
                three[three.indexWhere((a) => a.id == node.child[i + 1])].child
                    .length) {
              String temp = node.child[i];
              node.child[i] = node.child[i + 1];
              node.child[i + 1] = temp;
            }
          }
          else {
            if (three[three.indexWhere((a) => a.id == node.child[i])].child
                .length <
                three[three.indexWhere((a) => a.id == node.child[i + 1])].child
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
    double deltaDegNum = (node.child.length - 1)/2.0;
    double deg = originDeg - deltaDegNum*deltaDeg;
    double r;
    //print(node.child.length);

    if(node.child.length > 0){
      node.child.forEach((element) {
        r = 150.0;
        double x = r*cos(deg * (pi / 180.0)) + node.x;
        double y = r*sin(deg * (pi / 180.0)) + node.y;

        three[three.indexWhere((a) => a.id == element)].x = x;
        three[three.indexWhere((a) => a.id == element)].y = y;
        nodeRecursion(three[three.indexWhere((a) => a.id == element)], deg, three);
        deg = deg + deltaDeg;
      });
    }
    else{
    }
  }

  void setVerticesPos(Offset size){
    int x;
    int y;
    Random rand = new Random();

    balloon = BalloonTreeController()
    ..relationToNodes(relations, concepts);

    balloon.three[balloon.three.indexWhere((element) => element.parent == "-1")].x = size.dx/2;
    balloon.three[balloon.three.indexWhere((element) => element.parent == "-1")].y = size.dy/2;

    var branch = balloon.three.where((element) => element.parent ==
        balloon.three[balloon.three.indexWhere((element) => element.parent == "-1")].id);
    double startDeg = 45.0;
    double r = 150.0;
    branch.forEach((element) {
      double x = r*cos(startDeg * (pi / 180.0)) + size.dx/2;
      double y = r*sin(startDeg * (pi / 180.0)) + size.dy/2;

      balloon.three[balloon.three.indexWhere((a) => a.id == element.id)].x = x;
      balloon.three[balloon.three.indexWhere((a) => a.id == element.id)].y = y;

      nodeRecursion(balloon.three[balloon.three.indexWhere((a) => a.id == element.id)], startDeg, balloon.three);

      startDeg = startDeg + 360.0/branch.length.toDouble();
    });

    balloon.three.forEach((element) {
        vertices[vertices.indexWhere((a) => a.id == element.id)].position = Vector2(element.x, element.y);
    });

    /*
    vertices.forEach((element) {
      x = rand.nextInt(size.dx.toInt() - 100);
      y = rand.nextInt(size.dy.toInt() - 100);
      element.position = Vector2(x.toDouble(), y.toDouble());
    });

     */
  }

  double fAttr(var l, var x){
    return x*x/l;
  }

  double fRep(var l, var x){
    return 4*l*l/x;
  }

  double euDistance(Vector2 p){
    return p.x*p.x - p.y*p.y;
  }


  void forceCalc(var size,var iter){
    //var area = size.width*size.height;
    var side = 1000;
    var area = side*side;
    var forceRadius = 500;
    var dis;
    var l = sqrt(area/vertices.length);
    var i = 0;
    double t = side/2;
    Vector2 delta = new Vector2(0, 0);
    while(i < iter){
      vertices.forEach((v) {
        if(v.isOn == false){
          v.displacement = new Vector2(0, 0);
          vertices.forEach((u) {
            if(v.id != u.id){
              if(v.position.x == u.position.x){
                v.position.x++;
              }

              dis = sqrt((v.position.x - u.position.x)*(v.position.x - u.position.x) + (v.position.y - u.position.y)*(v.position.y - u.position.y));
              if(dis <= forceRadius){
                delta.x = v.position.x - u.position.x;
                delta.y = v.position.y - u.position.y;

                delta.x = delta.x*fRep(l, delta.length)/delta.length;
                delta.y = delta.y*fRep(l, delta.length)/delta.length;

                v.displacement.x = v.displacement.x + delta.x;
                v.displacement.y = v.displacement.y + delta.y;
              }
            }
          });
          edges.forEach((element) {
            if(element.u.id != v.id && element.v.id != v.id){
              double halfX = (element.u.position.x + element.v.position.x)/2;
              double halfY = (element.u.position.y + element.v.position.y)/2;
              dis = sqrt((v.position.x - halfX)*(v.position.x - halfX) +
                      (v.position.y - halfY)*(v.position.y - halfY));
              if(dis <= forceRadius){
                delta.x = v.position.x - halfX;
                delta.y = v.position.y - halfY;

                delta.x = delta.x*fRep(l, delta.length)/delta.length;
                delta.y = delta.y*fRep(l, delta.length)/delta.length;

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

        delta.x = delta.x*fAttr(l, delta.length)/delta.length;
        delta.y = delta.y*fAttr(l, delta.length)/delta.length;

        e.v.displacement.x = e.v.displacement.x - delta.x;
        e.v.displacement.y = e.v.displacement.y - delta.y;

        e.u.displacement.x = e.u.displacement.x + delta.x;
        e.u.displacement.y = e.u.displacement.y + delta.y;
      });

      vertices.forEach((v) {
        if(v.isOn == false){

          v.position.x = v.position.x + v.displacement.x*
              test3(iter, i)/
              v.displacement.length;
          v.position.y = v.position.y + v.displacement.y*
              test3(iter, i)/
              v.displacement.length;

          v.displacementPrev = v.displacement.length;
          v.position.x = min(size.dx, max(0, v.position.x));
          v.position.y = min(size.dy, max(0, v.position.y));

        }
      t = test(size, iter, i);
      });

      i++;
    }

  }

  int test3(int iter, int i){
    Random rand = Random();
    int r = rand.nextInt(10);
    if(r == 1){
      return iter;
    }else{
      return iter - i;
    }
  }

  double test2(Offset size, double displacement, double displacementPrev, int iMax, int i, double t){

    if(displacement > displacementPrev) {
      double e = exp(-displacement / t);
      Random rand = Random();
      int r = rand.nextInt(1);
      if (r <= e) {
        return test(size, iMax, i) + test(size, iMax, i);
      }
      else {
        return test(size, iMax, i);
      }
    }
      else{
      return test(size, iMax, i);
    }
  }

  double test(Offset size, int iMax, int i){
    return size.dx/2 - (size.dx*(i + 1))/(2*iMax) + 1;
  }

  double temperature(double displacement, double i, int iMax, double frameWidth) {
    double value = frameWidth / 2;
    if (displacement < value) {
      value = displacement;
    }

    i /= iMax / 2;
    if (i < 1) {
      return - value / 2 * i * i * i * i * i + value;
    }
    i -= 2;
    return - value / 2 * (i * i * i * i * i + 2) + value;
  }

}