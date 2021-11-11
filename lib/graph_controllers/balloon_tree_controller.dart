import 'package:concept_maps/models/graph_entities/concept_header.dart';
import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/models/graph_entities/relations.dart';
import 'package:concept_maps/models/general_entities/concept.dart';
import 'package:concept_maps/models/graph_entities/vertice.dart';
import 'package:concept_maps/utils/node_value_list.dart';
import 'package:flutter/material.dart';

class BalloonTreeController {
  BalloonTreeController();

  List<Node> three = [];
  String firstId;


  void setNode(Concept concept, Node parent, List<Relation> relations, List<Concept> concepts, int depth){
    if(three.where((a) => a.id == concept.id).length == 0){
      if(concept.isAspect == "1"){
        three.add(Node(concept.id, [], parent.id, concept.concept, NodeValueList.color[0][0], NodeValueList.color[0][1], NodeValueList.size.last, "1"));
      }else{
        three.add(Node(concept.id, [], parent.id, concept.concept, NodeValueList.color[depth+1][0], NodeValueList.color[depth+1][1], NodeValueList.size[depth], "0"));
      }
      if(concept.type == "unattached"){
        three.last.d = 30.0;
        three.last.mainColor = Colors.blueGrey;
        three.last.sideColor = Colors.grey;
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

  List<Node> relationToNodes(MapModel map){
    three.clear();
      map.relations.removeWhere((a) => a.relationClass == "c2c-similar");

    firstId = map.headerConcepts[0].conceptId;

    List<Concept> unattached = [];
    map.concepts.forEach((a) {
      bool isExist = false;
      if(a.isAspect == "0"){
        map.relations.forEach((b) {
          if(a.id == b.conceptId){
            isExist = true;
          }
        });
        if(isExist == false && a.id != firstId){
          unattached.add(a);
          print(a.toString());
        }
      }
    });
    if(unattached.length > 0 && map.age < 2){
      map.concepts.add(Concept(
          id: "0",
          concept: "<usage>",
          isAspect: "0",
          aspectOf: null
      ));
      map.concepts.last.type = "unattached";
      unattached.asMap().forEach((key, element) {
        map.relations.add(Relation(
            id: "1$key",
            conceptId: element.id.toString(),
            toConceptId: map.concepts.last.id.toString(),
            relationClass: "c2c-part-of"
        ));
      });

      map.relations.add(Relation(
          id: "0",
          conceptId: map.concepts.last.id.toString(),
          toConceptId: firstId,
          relationClass: "imaginary"
      ));
    }



    map.concepts.forEach((a) {
      if(a.isAspect == "1" && map.age < 2){
        map.relations.add(Relation(id:"", conceptId: a.id, toConceptId: a.aspectOf));
      }
    });
    setNode(map.concepts.firstWhere((a) => a.id == firstId),
        Node("-1", [], "-1", "-1", Colors.deepPurpleAccent, Colors.deepPurpleAccent), map.relations, map.concepts, 0);
    three.forEach((a) {
      //print([a.id, a.title, a.child, a.parent]);
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
