import 'package:concept_maps/models/general_entities/concept.dart';
import 'package:concept_maps/models/graph_entities/relations.dart';
import 'package:concept_maps/models/graph_entities/concept_header.dart';
import 'package:flutter/foundation.dart';

class MapModel {
  List<Relation> relations;
  List<Concept> concepts;
  List<ConceptHeader> headerConcepts;
  String field;
  int age;

  MapModel({
    @required this.relations,
    @required this.concepts,
    @required this.headerConcepts,
    @required this.field,
  }): age = 0;

  MapModel copyWith({
    List<Relation> relations,
    List<Concept> concepts,
    List<ConceptHeader> headerConcepts,
    String field,
  }) {
    return MapModel(
      relations: relations ?? this.relations,
      concepts: concepts ?? this.concepts,
      headerConcepts: headerConcepts ?? this.headerConcepts,
      field: field ?? this.field,
    );
  }

  factory MapModel.fromMap(
      String field,
      List relations,
      List concepts,
      List headerConcepts
      ) {
    return MapModel(
      relations:
      relations.map<Relation>((json) => Relation.fromJson(json)).toList(),
      concepts:
      concepts.map<Concept>((json) => Concept.fromJson(json)).toList(),
      headerConcepts:
      headerConcepts.map<ConceptHeader>((json) => ConceptHeader.fromJson(json)).toList(),
      field: field,
    );
  }

  @override
  String toString() =>
      'MapModel(relations: $relations, concepts: $concepts, header concepts: $headerConcepts, field: $field)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MapModel &&
        listEquals(other.relations, relations) &&
        listEquals(other.concepts, concepts) &&
        other.field == field;
  }

  @override
  int get hashCode => relations.hashCode ^ concepts.hashCode ^ field.hashCode;
}
