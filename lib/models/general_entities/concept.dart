class Concept {
  final String id;
  final String concept;
  final String isAspect;
  final String aspectOf;
  final String forms;
  String type;

  int get iid => int.tryParse(id);

  Concept({this.id, this.concept, this.isAspect, this.aspectOf, this.forms}): this.type = "normal";

  factory Concept.fromJson(Map<String, dynamic> parsedJson) {
    return Concept(
        id: parsedJson['id'],
        concept: parsedJson['concept'],
        isAspect: parsedJson['isAspect'],
        aspectOf: parsedJson['aspectOf'],
        forms: parsedJson['forms']);
  }

  @override
  String toString() {
    return 'Concept(id: $id, concept: $concept, isAspect: $isAspect, aspectOf: $aspectOf)';
  }
}
