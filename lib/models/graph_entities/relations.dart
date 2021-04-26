class Relations{
  final List<Relation> relations;

  Relations({this.relations});

  factory Relations.fromJson(List<dynamic> parsedJson){

    List<Relation> rs = [];
    rs = parsedJson.map((i)=>Relation.fromJson(i)).toList();

    return new Relations(
        relations: rs
    );
  }

}

class Relation{
  final String id;
  final String conceptId;
  final String toConceptId;
  final String relationClass;

  Relation({this.id, this.conceptId, this.toConceptId, this.relationClass});

  factory Relation.fromJson(Map<String, dynamic> parsedJson){
    return Relation(
        id: parsedJson['id'],
        conceptId: parsedJson['concept_id'],
        toConceptId: parsedJson['to_concept_id'],
        relationClass: parsedJson['class']
    );
  }
}