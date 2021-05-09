import 'package:concept_maps/models/enums/thesis_type.dart';
import 'package:concept_maps/models/general_entities/thesis.dart';
import 'package:concept_maps/views/text_templates/definition.dart';
import 'package:concept_maps/views/text_templates/democode.dart';
import 'package:concept_maps/views/text_templates/denotation.dart';
import 'package:concept_maps/views/text_templates/essence.dart';
import 'package:concept_maps/views/text_templates/note.dart';
import 'package:concept_maps/views/text_templates/tag.dart';
import 'package:flutter/material.dart';

class ThesisViewBuilder extends StatelessWidget {
  final Thesis thesis;
  const ThesisViewBuilder({Key key, @required this.thesis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final type = thesis.type;
    final text = thesis.data;

    switch (type) {
      case ThesisType.essence:
        return Essence(text);
      case ThesisType.definition:
        return Definition(text);
      case ThesisType.democode:
        return Democode(text);
      case ThesisType.denotation:
        return Denotation(text);
      case ThesisType.note:
        return Note(text);
      case ThesisType.tag:
        return Tag(text);
      default:
        return SizedBox.shrink();
    }
  }
}
