import 'package:concept_maps/models/dedactic_relations_entities/concept_in_theses.dart';
import 'package:concept_maps/models/general_entities/concept.dart';
import 'package:concept_maps/models/general_entities/thesis.dart';
import 'package:concept_maps/models/graph_entities/concept_header.dart';
import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/services/api_service.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  List<MapModel> maps;
  MapModel _currentMap;
  List<ConceptHeader> headerConcepts;

  ///Key - concept id, value - Thesis
  Map<int, List<Thesis>> _conceptTheses = {};
  List<ConceptInTheses> _conceptReferences = [];
  // Key - focus node id, value List of didactic concepts after
  Map<int, List<Concept>> didacticConceptsAfter = {};

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

  ///Use this to get all CinT references for a selected concept
  Future<ConceptInTheses> fetchConceptInTheses(int conceptId) async {
    if (!_conceptReferences.any((element) => element.id == conceptId)) {
      _conceptReferences.add(await ApiService.fecthConceptsInTheses(conceptId));
    }

    return _conceptReferences.firstWhere((element) => element.id == conceptId,
        orElse: () => null);
  }

  //Use this to get all ConceptsDidacticAfter references foa a selected concept id
  Future<List<Concept>> fetchConceptsDidacticAfter(int conceptId) async {
    if (!didacticConceptsAfter.keys.any((element) => element == conceptId)) {
      didacticConceptsAfter[conceptId] =
          await ApiService.fetchConceptsDidacticAfter(conceptId);
    }
    return didacticConceptsAfter[conceptId];
  }

  Future<List<Thesis>> fetchTheses(List<int> thesisIds) async {
    return await ApiService.fetchTheses(thesisIds);
  }

  Node focusNode;
  bool bottomSheetFlag;

  String animationId;
  bool animationStart = false;

  List<Node> tree;

  List<String> recentList = ["Dart", "String"];

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

  void addSearchHistory(String recentItem) {
    recentList.insert(0, recentItem);
  }

  void removeSearchHistory() {
    recentList.removeLast();
  }
}
