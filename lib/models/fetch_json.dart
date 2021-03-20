import 'package:concept_maps/models/graph_entities/relations.dart';
import 'package:concept_maps/models/graph_entities/concept.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FetchJSON {
  var relations;
  var concepts;
  String field;

  FetchJSON(this.field);

  parse() async {
    String url = "https://semantic-portal.net/api/branch/" +
        field +
        "/concepts/relations";
    String concepts_url =
        "https://semantic-portal.net/api/branch/" + field + "/concepts";

    final response = await http.get(url);
    final concepts_response = await http.get(concepts_url);

    print(response.body);
    print(concepts_response.body);
    if (response.statusCode == 200 && concepts_response.statusCode == 200) {
      var decode_res = jsonDecode(response.body);
      var raw_list = decode_res as List;
      var relations_list =
          raw_list.map<Relation>((json) => Relation.fromJson(json)).toList();

      var decode_cons = jsonDecode(concepts_response.body);
      var cons_raw_list = decode_cons as List;
      var concepts_list =
          cons_raw_list.map<Concept>((json) => Concept.fromJson(json)).toList();

      relations = relations_list;
      concepts = concepts_list;
      return relations;
    } else {
      print("error");
    }
  }
}
