import 'package:concept_maps/models/dedactic_relations_entities/concept_in_theses.dart';
import 'package:concept_maps/models/enums/thesis_type.dart';
import 'package:concept_maps/models/general_entities/concept.dart';
import 'package:concept_maps/models/general_entities/thesis.dart';
import 'package:concept_maps/models/graph_entities/concept_header.dart';
import 'package:concept_maps/models/graph_entities/edge.dart';
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
  Future<List<Thesis>> fetchThesesByConcept(int conceptId) async {
    _conceptTheses[conceptId] ??=
        (await ApiService.fetchThesesByConceptId(conceptId))
            .where((element) => element.type != ThesisType.other)
            .toList();
    return _conceptTheses[conceptId];
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

  Future<List<Thesis>> fetchEdgeTheses(int conceptId1, int conceptId2) async {
    ConceptInTheses conceptInTheses1 = await fetchConceptInTheses(currentMap
        .concepts
        .firstWhere((a) => a.id == conceptId1.toString())
        .iid);
    //ConceptInTheses conceptInTheses2 =
    //  await fetchConceptInTheses(
    //      currentMap.concepts.firstWhere((a) => a.id == focusEdge.v.id));

    List<int> thesisIdsU = [];
    List<int> thesisIdsV = [];
    conceptInTheses1.innerReferences.forEach((element) {
      if (element.conceptId.toString() == conceptId2.toString()) {
        thesisIdsU.add(element.thesisId);
      }
    });

    conceptInTheses1.outerReferences.forEach((element) {
      if (element.conceptId.toString() == conceptId2.toString()) {
        thesisIdsU.add(element.thesisId);
      }
    });

    return fetchTheses(thesisIdsU);
  }

  Future<List<Thesis>> fetchThesesByConceptFork(int conceptId) async {
    if (isEdgeActive) {
      return fetchEdgeTheses(
          int.parse(focusEdge.u.id), int.parse(focusEdge.v.id));
    } else {
      return fetchThesesByConcept(conceptId);
    }
  }

  Future<List<Thesis>> fetchTheses1(List<int> thesisIds) async {
    return await ApiService.fetchTheses(thesisIds);
  }

  Node focusNode;
  String focusTitle = "";
  bool isEdgeActive = false;
  Edge focusEdge;
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
