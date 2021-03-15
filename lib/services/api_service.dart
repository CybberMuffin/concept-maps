import 'dart:convert';
import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:http/http.dart' as http;

abstract class ApiService {
  static Future<MapModel> fetchConceptRelations(String field) async {
    String relationsUrl =
        "https://semantic-portal.net/api/branch/$field/concepts/relations";
    String conceptsUrl =
        "https://semantic-portal.net/api/branch/$field/concepts";

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
      final relationsResult = jsonDecode(relationsResponse.body);
      final conceptsResult = jsonDecode(conceptsResponse.body);

      return MapModel(
        field: field,
        relations: relationsResult,
        concepts: conceptsResult,
      );
    } else {
      throw Exception("Error ocured during fetch of map model");
    }
  }
}
