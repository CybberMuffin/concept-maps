import 'package:concept_maps/models/dedactic_relations_entities/concept_in_theses.dart';
import 'package:concept_maps/models/general_entities/concept.dart';
import 'package:concept_maps/models/general_entities/thesis.dart';
import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:concept_maps/models/graph_entities/node.dart';

class AppProvider with ChangeNotifier {
  List<MapModel> maps;
  MapModel _currentMap;

  ///Key - concept id, value - Thesis
  Map<int, List<Thesis>> _conceptTheses = {};
  List<ConceptInTheses> _conceptReferences = [];

  MapModel get currentMap => _currentMap;

  set currentMap(MapModel currentMap) {
    _currentMap = currentMap;
    notifyListeners();
  }

  Future<void> fetchAllMaps() async {
    maps ??= await ApiService.fetchBranches();
  }

  ///Use this to get all related theses to a selected concept
  Future<List<Thesis>> fetchThesesByConcept(Concept concept) async {
    _conceptTheses[concept.iid] ??=
        await ApiService.fetchThesesByConceptId(concept.iid);
    return _conceptTheses[concept.iid];
  }

  ///Use this to get all CinT refrences for a selected concept
  Future<ConceptInTheses> fetchConceptInTheses(Concept concept) async {
    if (!_conceptReferences.any((element) => element.id == concept.iid)) {
      _conceptReferences
          .add(await ApiService.fecthConceptsInTheses(concept.iid));
    }

    return _conceptReferences.firstWhere((element) => element.id == concept.iid,
        orElse: () => null);
  }

  Node focusNode;
  bool bottomSheetFlag;

  String animationId;
  bool animationStart = false;

  List<Node> tree;

  void setFocusNode(Node node) {
    focusNode = node;
    notifyListeners();
  }

  void setBottomSheetFlag(bool flag) {
    bottomSheetFlag = flag;
    notifyListeners();
  }

  void setAnimationParam(String id) {
    animationId = id;
    animationStart = true;
    notifyListeners();
  }

  void setTree(List<Node> t) {
    tree = t;
  }
}
