import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/models/graph_entities/relations.dart';
import 'package:concept_maps/models/graph_entities/concept.dart';

class BalloonTreeController {
  BalloonTreeController();

  List<Node> three = [];

  List<Node> relationToNodes(List<Relation> relations, List<Concept> concepts) {
    three.clear();
    var root = relations[0].to_concept_id;
    var raw_childs =
    relations.where((a) => a.to_concept_id == relations[0].to_concept_id);
    var childs = raw_childs.map((a) => a.concept_id).toList();

    three.add(Node(
        relations[0].to_concept_id,
        childs,
        "-1",
        concepts[concepts.indexWhere(
                (element) => element.id == relations[0].to_concept_id)]
            .concept));
    relations.forEach((element) {
      raw_childs =
          relations.where((a) => a.to_concept_id == element.concept_id);
      childs = raw_childs.map((a) => a.concept_id).toList();
      //print(element.concept_id);
      //print(childs);
      var parent = element.to_concept_id;
      three.add(Node(
          element.concept_id,
          childs,
          parent,
          concepts[concepts.indexWhere((a) => a.id == element.concept_id)]
              .concept));
    });

    concepts.forEach((element) {
      if (element.isAspect == "1") {
        if (three.indexWhere((a) => a.id == element.aspectOf) == -1) {
          findRelInNode(element, concepts);
        }

        three.add(Node(element.id, [], element.aspectOf, element.concept));
        three[three.indexWhere((a) => a.id == element.aspectOf)]
            .child
            .add(element.id);
      }
    });
    return three;
  }

  findRelInNode(Concept element, List<Concept> concepts) {
    Concept cons_parent =
    concepts[concepts.indexWhere((a) => a.id == element.aspectOf)];
    if (three.indexWhere((a) => a.id == cons_parent.aspectOf) == -1) {
      findRelInNode(cons_parent, concepts);
    }

    three.add(
        Node(cons_parent.id, [], cons_parent.aspectOf, cons_parent.concept));
    three[three.indexWhere((a) => a.id == cons_parent.aspectOf)]
        .child
        .add(cons_parent.id);
  }


}
