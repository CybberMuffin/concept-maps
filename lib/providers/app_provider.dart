import 'package:concept_maps/models/graph_entities/concept.dart';
import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/models/graph_entities/relations.dart';
import 'package:concept_maps/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:concept_maps/models/graph_entities/node.dart';

class AppProvider with ChangeNotifier {
  MapModel currentMap;
  Node focusNode;
  bool bottomSheetFlag;

  String animationId;
  bool animationStart = false;

  List<Node> tree;


  Future<MapModel> getMapModel(String field) async {
     if (field != currentMap?.field) currentMap = null;
     currentMap ??= await ApiService.fetchConceptRelations(field);
    // List<Concept> c = [
    //   Concept(id:"1", concept:"t1", isAspect:"0", aspectOf:"0"),
    //   Concept(id:"2", concept:"t2", isAspect:"0", aspectOf:"0"),
    //   Concept(id:"3", concept:"t3", isAspect:"0", aspectOf:"0"),
    //   Concept(id:"4", concept:"t4", isAspect:"0", aspectOf:"0"),
    //   Concept(id:"5", concept:"t5", isAspect:"0", aspectOf:"0"),
    //   Concept(id:"6", concept:"t6", isAspect:"0", aspectOf:"0"),
    //   Concept(id:"7", concept:"t7", isAspect:"0", aspectOf:"0"),
    //   Concept(id:"8", concept:"t8", isAspect:"0", aspectOf:"0"),
    //   Concept(id:"9", concept:"t9", isAspect:"0", aspectOf:"0"),
    //   Concept(id:"10", concept:"t10", isAspect:"0", aspectOf:"0"),
    // ];
    // List<Relation> r = [
    //   Relation(id: "11", concept_id: "1", to_concept_id: "2"),
    //   Relation(id: "22", concept_id: "1", to_concept_id: "3"),
    //   Relation(id: "33", concept_id: "1", to_concept_id: "4"),
    //   Relation(id: "44", concept_id: "2", to_concept_id: "5"),
    //   Relation(id: "55", concept_id: "2", to_concept_id: "6"),
    //   Relation(id: "66", concept_id: "3", to_concept_id: "7"),
    //   Relation(id: "77", concept_id: "3", to_concept_id: "8"),
    //   Relation(id: "88", concept_id: "3", to_concept_id: "9"),
    //   Relation(id: "99", concept_id: "4", to_concept_id: "10"),
    // ];
    // currentMap = MapModel(relations: r, concepts: c, field: field);
    return currentMap;
  }

  void setFocusNode(Node node){
    focusNode = node;
    notifyListeners();
  }

  void setBottomSheetFlag(bool flag){
    bottomSheetFlag = flag;
    notifyListeners();
  }

  void setAnimationParam(String id){
    animationId = id;
    animationStart = true;
    notifyListeners();
  }

  void setTree(List<Node> t){
    tree = t;
  }
}
