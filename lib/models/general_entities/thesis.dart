import 'package:concept_maps/models/enums/thesis_type.dart';
import 'package:flutter/foundation.dart';

class Thesis {
  int id;
  int conceptId;
  String data;
  ThesisType type;
  int hasConcept;
  int toThesisId;
  int toConceptId;

  Thesis({
    @required this.id,
    @required this.conceptId,
    @required this.data,
    @required this.type,
    @required this.hasConcept,
    @required this.toThesisId,
    @required this.toConceptId,
  });

  Thesis copyWith({
    int id,
    int conceptId,
    String data,
    ThesisType type,
    int hasConcept,
    int toThesisId,
    int toConceptId,
  }) {
    return Thesis(
      id: id ?? this.id,
      conceptId: conceptId ?? this.conceptId,
      data: data ?? this.data,
      type: type ?? this.type,
      hasConcept: hasConcept ?? this.hasConcept,
      toThesisId: toThesisId ?? this.toThesisId,
      toConceptId: toConceptId ?? this.toConceptId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conceptId': conceptId,
      'data': data,
      'type': type.toString(),
      'hasConcept': hasConcept,
      'toThesisId': toThesisId,
      'toConceptId': toConceptId,
    };
  }

  factory Thesis.fromMap(Map<String, dynamic> map) {
    return Thesis(
      id: int.parse(map['id']),
      conceptId: int.parse(map['concept_id']),
      data: map['thesis'],
      type: _convertToType(map['class']),
      hasConcept:
          map['hasConcept'] != null ? int.tryParse(map['hasConcept']) : null,
      toThesisId: map['to_thesis_id'] != null
          ? int.tryParse(map['to_thesis_id'])
          : null,
      toConceptId: map['to_concept_id'] != null
          ? int.tryParse(map['to_concept_id'])
          : null,
    );
  }

  static ThesisType _convertToType(String type) {
    switch (type) {
      case 'essence':
        return ThesisType.essence;
      case 'definition':
        return ThesisType.definition;
      case 'democode':
        return ThesisType.democode;
      case 'denotation':
        return ThesisType.denotation;
      default:
        return ThesisType.other;
    }
  }

  @override
  String toString() {
    return 'Thesis(id: $id, conceptId: $conceptId, data: $data, hasConcept: $hasConcept, toThesisId: $toThesisId, toConceptId: $toConceptId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Thesis &&
        other.id == id &&
        other.conceptId == conceptId &&
        other.data == data &&
        other.hasConcept == hasConcept &&
        other.toThesisId == toThesisId &&
        other.toConceptId == toConceptId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        conceptId.hashCode ^
        data.hashCode ^
        hasConcept.hashCode ^
        toThesisId.hashCode ^
        toConceptId.hashCode;
  }
}
