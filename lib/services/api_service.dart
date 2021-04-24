import 'dart:convert';
import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/utils/course_key_list.dart';
import 'package:http/http.dart' as http;

abstract class ApiService {
  static const String _apiUrl = "https://semantic-portal.net";

  static Future<MapModel> _fetchConceptRelations(String field) async {
    String relationsUrl = "$_apiUrl/api/branch/$field/concepts/relations";
    String conceptsUrl = "$_apiUrl/api/branch/$field/concepts";

    final response = await Future.wait<http.Response>(
      [
        http.get(relationsUrl),
        http.get(conceptsUrl),
      ],
    );

    final relationsResponse = response.first;
    final conceptsResponse = response[1];

    if (relationsResponse.statusCode == 200 &&
        conceptsResponse.statusCode == 200) {
      final List relationsResult = jsonDecode(relationsResponse.body);
      final List conceptsResult = jsonDecode(conceptsResponse.body);

      return MapModel.fromMap(
        field,
        relationsResult,
        conceptsResult,
      );
    } else {
      throw Exception("Error occured during fetch of map model");
    }
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
}
