import 'package:flutter/foundation.dart';
import 'package:concept_maps/models/dedactic_relations_entities/concept_reference.dart';

class ConceptInTheses {
  int id;

  ///This concept refences on other concepts
  List<ConceptReference> innerReferences = [];

  ///Other concepts refences on this concept
  List<ConceptReference> outerReferences = [];
  ConceptInTheses({
    @required this.id,
    @required this.innerReferences,
    @required this.outerReferences,
  });

  ConceptInTheses copyWith({
    int id,
    List<ConceptReference> innerReferences,
    List<ConceptReference> outerReferences,
  }) {
    return ConceptInTheses(
      id: id ?? this.id,
      innerReferences: innerReferences ?? this.innerReferences,
      outerReferences: outerReferences ?? this.outerReferences,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'thisConcept': innerReferences?.map((x) => x.toMap())?.toList(),
      'otherConcepts': outerReferences?.map((x) => x.toMap())?.toList(),
    };
  }

  factory ConceptInTheses.fromMap(Map<String, dynamic> map, int conceptId) {
    return ConceptInTheses(
      id: conceptId,
      innerReferences: List<ConceptReference>.from(
          map['thisConcept']?.map((x) => ConceptReference.fromMap(x))),
      outerReferences: List<ConceptReference>.from(
          map['otherConcepts']?.map((x) => ConceptReference.fromMap(x))),
    );
  }

  @override
  String toString() =>
      'ConceptInTheses(id: $id, innerReferences: $innerReferences, outerReferences: $outerReferences)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConceptInTheses &&
        other.id == id &&
        listEquals(other.innerReferences, innerReferences) &&
        listEquals(other.outerReferences, outerReferences);
  }

  @override
  int get hashCode =>
      id.hashCode ^ innerReferences.hashCode ^ outerReferences.hashCode;
}
