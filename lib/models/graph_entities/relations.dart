class Relations {
  final List<Relation> relations;

  Relations({this.relations});

  factory Relations.fromJson(List<dynamic> parsedJson) {
    List<Relation> rs = [];
    rs = parsedJson.map((i) => Relation.fromJson(i)).toList();

    return new Relations(relations: rs);
  }
}

class Relation {
  final String id;
  final String concept_id;
  final String to_concept_id;
  final String view;

  Relation({this.id, this.concept_id, this.to_concept_id, this.view});

  factory Relation.fromJson(Map<String, dynamic> parsedJson) {
    return Relation(
        id: parsedJson['id'],
        concept_id: parsedJson['concept_id'],
        to_concept_id: parsedJson['to_concept_id'],
        view: parsedJson['view']);
  }
}
