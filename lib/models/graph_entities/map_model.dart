import 'package:flutter/foundation.dart';
import 'package:concept_maps/models/graph_entities/Concept.dart';
import 'package:concept_maps/models/graph_entities/Relations.dart';

class MapModel {
  List<Relation> relations;
  List<Concept> concepts;
  String field;

  MapModel({
    @required this.relations,
    @required this.concepts,
    @required this.field,
  });

  MapModel copyWith({
    List<Relation> relations,
    List<Concept> concepts,
    String field,
  }) {
    return MapModel(
      relations: relations ?? this.relations,
      concepts: concepts ?? this.concepts,
      field: field ?? this.field,
    );
  }

  factory MapModel.fromMap(
    String field,
    dynamic relations,
    dynamic concepts,
  ) {
    return MapModel(
      relations: (relations as List)
          .map<Relation>((json) => Relation.fromJson(json))
          .toList(),
      concepts: (concepts as List)
          .map<Concept>((json) => Concept.fromJson(json))
          .toList(),
      field: field,
    );
  }

  @override
  String toString() =>
      'MapModel(relations: $relations, concepts: $concepts, field: $field)';

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
