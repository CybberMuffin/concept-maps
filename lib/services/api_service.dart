import 'dart:convert';
import 'package:concept_maps/models/dedactic_relations_entities/concept_in_theses.dart';
import 'package:concept_maps/models/general_entities/concept.dart';
import 'package:concept_maps/models/general_entities/thesis.dart';
import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/models/graph_entities/concept_header.dart';
import 'package:concept_maps/utils/course_key_list.dart';
import 'package:http/http.dart' as http;

abstract class ApiService {
  static const String _hostUrl = "https://semantic-portal.net";

  static Future<MapModel> _fetchConceptRelations(String field) async {
    final String relationsUrl =
        "$_hostUrl/api/branch/$field/concepts/relations";
    final String conceptsUrl = "$_hostUrl/api/branch/$field/concepts";
    final String headerUrl = "$_hostUrl/api/CinH/$field";

    final response = await Future.wait<http.Response>(
      [
        http.get(relationsUrl),
        http.get(conceptsUrl),
        http.get(headerUrl)
      ],
    );

    final relationsResponse = response.first;
    final conceptsResponse = response[1];
    final headerResponse = response[2];

    if (relationsResponse.statusCode == 200 &&
        conceptsResponse.statusCode == 200) {
      final List relationsResult = jsonDecode(relationsResponse.body);
      final List conceptsResult = jsonDecode(conceptsResponse.body);
      final List headerResult = jsonDecode(headerResponse.body);

      return MapModel.fromMap(
        field,
        relationsResult,
        conceptsResult,
        headerResult
      );
    }

    throw Exception("Error occured during fetch of map model");
  }

  static Future<List<MapModel>> fetchBranches() async {
    final List<MapModel> maps = await Future.wait<MapModel>(
      CourseListInfo.courseKeyList
          .sublist(0, 9)
          .map<Future<MapModel>>((key) => _fetchConceptRelations(key))
          .toList(),
    );

    return maps;
  }

  static Future<ConceptInTheses> fecthConceptsInTheses(int conceptId) async {
    assert(conceptId != null);
    final url = '$_hostUrl/api/concept/$conceptId/CinT';

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return ConceptInTheses.fromMap(result, conceptId);
    }

    throw Exception("Error occured during fetch of concepts in theses");
  }

  static Future<List<Concept>> fetchConceptsDidacticBefore(
      int conceptId) async {
    assert(conceptId != null);
    final url = '$_hostUrl/api/concept/$conceptId/didactic/before';

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return List<Concept>.from(
        result?.map((x) => Concept.fromJson(x)),
      );
    }

    throw Exception(
        "Error occured during fetch of concepts in didactic before");
  }

  static Future<List<Concept>> fetchConceptsDidacticAfter(int conceptId) async {
    assert(conceptId != null);
    final url = '$_hostUrl/api/concept/$conceptId/didactic/after';

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return List<Concept>.from(
        result?.map((x) => Concept.fromJson(x)),
      );
    }

    throw Exception("Error occured during fetch of concepts in didactic after");
  }

  static Future<List<Thesis>> fetchThesesByConceptId(int conceptId) async {
    assert(conceptId != null);
    final url = '$_hostUrl/api/concept/$conceptId/thesis';

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return List<Thesis>.from(
        result?.map((x) => Thesis.fromMap(x)),
      );
    }

    throw Exception("Error occured during fetch of theses by concept id");
  }

  static Future<List<Thesis>> fetchTheses(List<int> thesisIds) async {
    assert(thesisIds != null);
    assert(thesisIds.isNotEmpty);

    final thesisIdsStr = thesisIds.join(",");
    final url = '$_hostUrl/api/thesis/$thesisIdsStr';

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return List<Thesis>.from(
        result?.map((x) => Thesis.fromMap(x)),
      );
    }

    throw Exception("Error occured during fetch of selected theses");
  }

}
