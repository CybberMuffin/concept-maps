import 'package:flutter/material.dart';

class ConceptReference {
  int conceptId;
  int thesisId;
  int count;
  ConceptReference({
    @required this.conceptId,
    @required this.thesisId,
    @required this.count,
  });

  ConceptReference copyWith({
    int conceptId,
    int thesisId,
    int count,
  }) {
    return ConceptReference(
      conceptId: conceptId ?? this.conceptId,
      thesisId: thesisId ?? this.thesisId,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'conceptId': conceptId,
      'thesisId': thesisId,
      'count': count,
    };
  }

  factory ConceptReference.fromMap(Map<String, dynamic> map) {
    return ConceptReference(
      conceptId: int.parse(map['concept_id']),
      thesisId: int.parse(map['thesis_id']),
      count: int.parse(map['count']),
    );
  }

  @override
  String toString() =>
      'ConceptReference(conceptId: $conceptId, thesisId: $thesisId, count: $count)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConceptReference &&
        other.conceptId == conceptId &&
        other.thesisId == thesisId &&
        other.count == count;
  }

  @override
  int get hashCode => conceptId.hashCode ^ thesisId.hashCode ^ count.hashCode;
}
