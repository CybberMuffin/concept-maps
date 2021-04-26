import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/models/graph_entities/relations.dart';
import 'package:concept_maps/models/graph_entities/concept.dart';
import 'package:concept_maps/models/graph_entities/vertice.dart';
import 'package:concept_maps/utils/node_value_list.dart';
import 'package:flutter/material.dart';

class BalloonTreeController {
  BalloonTreeController();

  List<Node> three = [];


  void setNode(Concept concept, Node parent, List<Relation> relations, List<Concept> concepts, int depth){
    if(three.where((a) => a.id == concept.id).length == 0){
      if(concept.isAspect == "1"){
        three.add(Node(concept.id, [], parent.id, concept.concept, NodeValueList.color[0][0], NodeValueList.color[0][1], NodeValueList.size.last));
      }else{
        three.add(Node(concept.id, [], parent.id, concept.concept, NodeValueList.color[depth+1][0], NodeValueList.color[depth+1][1], NodeValueList.size[depth]));
      }

      List<String> childs = relations.where((a) => a.toConceptId == concept.id).map((e) => e.conceptId).toList();
      int currentIndex = three.indexWhere((a) => a.id == concept.id);
      childs.forEach((a) {
        three[currentIndex].child.add(a);
        depth++;
        setNode(concepts.firstWhere((b) => b.id == a),
            three[currentIndex], relations, concepts, depth);
        depth--;

      });
    }
  }

  List<Node> relationToNodes(List<Relation> relations, List<Concept> concepts){
    three.clear();
    String firstId;
    relations.forEach((element) {
      if(element.relationClass != "c2c-part-of")
        print(element.relationClass);
    });
    relations.removeWhere((a) => a.relationClass == "c2c-similar");
    concepts.forEach((a) {
      bool isExist = false;
      if(a.isAspect == "0"){
        relations.forEach((b) {
          if(a.id == b.conceptId){
            isExist = true;
          }
        });
        if(isExist == false){
          firstId = a.id;
        }
      }
    });
    concepts.forEach((a) {
      if(a.isAspect == "1"){
        relations.add(Relation(id:"", conceptId: a.id, toConceptId: a.aspectOf));
      }
    });
    setNode(concepts.firstWhere((a) => a.id == firstId),
        Node("-1", [], "-1", "-1", Colors.deepPurpleAccent, Colors.deepPurpleAccent), relations, concepts, 0);
    three.forEach((a) {
      print([a.id, a.title, a.child, a.parent]);
    });
  }

  // List<Node> relationToNodes2(List<Relation> relations, List<Concept> concepts) {
  //   three.clear();
  //   var root = relations[0].to_concept_id;
  //   var raw_childs =
  //       relations.where((a) => a.to_concept_id == relations[0].to_concept_id);
  //   var childs = raw_childs.map((a) => a.concept_id).toList();
  //
  //   three.add(Node(
  //       relations[0].to_concept_id,
  //       childs,
  //       "-1",
  //       concepts[concepts.indexWhere(
  //               (element) => element.id == relations[0].to_concept_id)]
  //           .concept));
  //   relations.forEach((element) {
  //     raw_childs =
  //         relations.where((a) => a.to_concept_id == element.concept_id);
  //     childs = raw_childs.map((a) => a.concept_id).toList();
  //     //print(element.concept_id);
  //     //print(childs);
  //     var parent = element.to_concept_id;
  //     three.add(Node(
  //         element.concept_id,
  //         childs,
  //         parent,
  //         concepts[concepts.indexWhere((a) => a.id == element.concept_id)]
  //             .concept));
  //   });
  //
  //   concepts.forEach((element) {
  //     if (element.isAspect == "1") {
  //       if (three.indexWhere((a) => a.id == element.aspectOf) == -1) {
  //         findRelInNode(element, concepts);
  //       }
  //
  //       three.add(Node(element.id, [], element.aspectOf, element.concept));
  //       three[three.indexWhere((a) => a.id == element.aspectOf)]
  //           .child
  //           .add(element.id);
  //     }
  //   });
  //   three.forEach((element) {
  //     print(element.id);
  //     print(element.title);
  //     print("!!!!!!!!!!!!!");
  //   });
  //   return three;
  // }
  //
  // findRelInNode(Concept element, List<Concept> concepts) {
  //   Concept cons_parent =
  //       concepts[concepts.indexWhere((a) => a.id == element.aspectOf)];
  //   if (three.indexWhere((a) => a.id == cons_parent.aspectOf) == -1) {
  //     findRelInNode(cons_parent, concepts);
  //   }
  //
  //   three.add(
  //       Node(cons_parent.id, [], cons_parent.aspectOf, cons_parent.concept));
  //   three[three.indexWhere((a) => a.id == cons_parent.aspectOf)]
  //       .child
  //       .add(cons_parent.id);
  // }


}
