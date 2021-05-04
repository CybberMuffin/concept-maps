class ConceptHeader {
  final String conceptId;
  final String view;
  final String hNum;

  int get iid => int.tryParse(conceptId);

  ConceptHeader({this.conceptId, this.view, this.hNum});

  factory ConceptHeader.fromJson(Map<String, dynamic> parsedJson) {
    return ConceptHeader(
        conceptId: parsedJson['concept_id'],
        view: parsedJson['view'],
        hNum: parsedJson['h_num']);
  }
}