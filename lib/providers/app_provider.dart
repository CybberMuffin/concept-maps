import 'package:concept_maps/models/dedactic_relations_entities/concept_in_theses.dart';
import 'package:concept_maps/models/enums/thesis_type.dart';
import 'package:concept_maps/models/general_entities/concept.dart';
import 'package:concept_maps/models/general_entities/thesis.dart';
import 'package:concept_maps/models/graph_entities/concept_header.dart';
import 'package:concept_maps/models/graph_entities/edge.dart';
import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/models/logs/user_log.dart';
import 'package:concept_maps/services/api_service.dart';
import 'package:concept_maps/utils/course_key_list.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  List<MapModel> maps = [];
  MapModel _currentMap;
  List<ConceptHeader> headerConcepts;

  ///Key - concept id, value - Thesis
  Map<int, List<Thesis>> _conceptTheses = {};
  List<ConceptInTheses> _conceptReferences = [];
  // Key - focus node id, value List of didactic concepts after
  Map<int, List<Concept>> didacticConceptsAfter = {};

  MapModel get currentMap => _currentMap;

  set currentMap(MapModel currentMap) {
    if (currentMap != null) {
      _currentMap = currentMap;
      notifyListeners();
    }
  }

  Future<void> fetchAllMaps() async {
    if (!maps
        .any((element) => element.field == CourseListInfo.courseKeyList.first))
      maps = await ApiService.fetchBranches();
  }

  Future<MapModel> fetchMapByBranch(String branchName) async {
    if (!maps.any((map) => map.field == branchName)) {
      maps.add(await ApiService.fetchConceptRelations(branchName));
    }
    currentMap =
        maps.firstWhere((map) => map.field == branchName, orElse: () => null);
    return currentMap;
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

  Future<List<Thesis>> fetchThesesByConceptFork(
      int conceptId, List<UserLog> conceptLogs) async {
    setCurrentConcept(
        currentMap.concepts.firstWhere((element) => element.iid == conceptId));
    setTimeSpentOnConcept(conceptLogs);
    if (isEdgeActive) {
      return fetchEdgeTheses(
          int.parse(focusEdge.u.id), int.parse(focusEdge.v.id));
    } else {
      return fetchThesesByConcept(conceptId ?? _currentMap.concepts.first.iid);
    }
  }

  Future<List<Thesis>> fetchTheses1(List<int> thesisIds) async {
    return await ApiService.fetchTheses(thesisIds);
  }

  Node focusNode;
  Concept currentConcept;
  String focusTitle = "";
  bool isEdgeActive = false;
  Edge focusEdge;
  bool bottomSheetFlag;

  String animationId;
  bool animationStart = false;

  List<Node> tree;

  List<String> recentList = ["Dart", "String"];

  void cleanFocusNodeTitle() {
    focusTitle = '';
  }

  void setFocusNode(Node node) {
    focusNode = node;
    //notifyListeners();
  }

  void setCurrentConcept(Concept concept) {
    currentConcept = concept;
  }

  void setTimeSpentOnConcept(List<UserLog> logs) {
    int secondsSpent = 0;
    logs.forEach((log) {
      if (log.seconds != null) {
        secondsSpent += int.tryParse(log.seconds);
      }
    });
    currentConcept.timeSpent = secondsSpent;
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
