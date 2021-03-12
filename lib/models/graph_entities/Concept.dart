class Concept{
  final String id;
  final String concept;
  final String isAspect;
  final String aspectOf;

  Concept({this.id, this.concept, this.isAspect, this.aspectOf});

  factory Concept.fromJson(Map<String, dynamic> parsedJson){
    return Concept(
        id: parsedJson['id'],
        concept: parsedJson['concept'],
        isAspect: parsedJson['isAspect'],
        aspectOf: parsedJson['aspectOf']
    );
  }
}