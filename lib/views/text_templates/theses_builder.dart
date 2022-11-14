import 'package:concept_maps/models/enums/thesis_type.dart';
import 'package:concept_maps/models/general_entities/concept.dart';
import 'package:concept_maps/models/general_entities/thesis.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/views/text_templates/definition.dart';
import 'package:concept_maps/views/text_templates/democode.dart';
import 'package:concept_maps/views/text_templates/denotation.dart';
import 'package:concept_maps/views/text_templates/essence.dart';
import 'package:concept_maps/views/text_templates/note.dart';
import 'package:concept_maps/views/text_templates/tag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meta/meta.dart';

class ThesisViewBuilder extends StatelessWidget {
  final Thesis thesis;
  final String languageName;
  Concept conceptU;
  Concept conceptV;
  ThesisViewBuilder(
      {Key key,
      @required this.thesis,
      this.conceptU,
      this.conceptV,
      @required this.languageName})
      : super(key: key);

  Widget formatingRichText(BuildContext context, TextStyle mainStyle) {
    final provider = context.read<AppProvider>();
    if (conceptU == null && conceptV == null) {
      return RichText(
          text: TextSpan(
        text: thesis.data,
        style: mainStyle,
      ));
    }

    List<InlineSpan> list = [];
    String c1s = conceptU.forms;
    String c2s = conceptV.forms;
    List<String> c1 = c1s.split("; ");
    List<String> c2 = c2s.split("; ");

    c1.add(conceptU.concept);
    c2.add(conceptV.concept);

    Map<String, String> mainMap = {};

    c1.forEach((element) {
      mainMap[element] = "1";
    });
    c2.forEach((element) {
      mainMap[element] = "2";
    });
    mainMap.remove("");
    List<String> splitThesis = thesis.data.replaceAll("\n", " ").split(" ");
    List<String> keys = mainMap.keys.toList();

    for (int m = 0; m < splitThesis.length; m++) {
      int i = 0;
      for (int j = 0; j < mainMap.length; j++) {
        TextStyle textStyle;
        List<String> formDecompose = keys[j].split(" ");
        if (formDecompose.length > 1) {
          if (m + formDecompose.length < splitThesis.length) {
            String check = splitThesis[m];
            for (int n = 1; n < formDecompose.length; n++) {
              check += " " + splitThesis[m + n];
            }
            if (check.replaceAll(RegExp(r'[:;,.!?]'), "") == keys[j]) {
              if (mainMap[keys[j]] == "1") {
                textStyle = TextStyle(
                    backgroundColor: provider.tree
                        .firstWhere((a) => a.id == conceptU.id)
                        .sideColor
                        .withOpacity(0.85));
              } else if (mainMap[keys[j]] == "2") {
                textStyle = TextStyle(
                    backgroundColor: provider.tree
                        .firstWhere((a) => a.id == conceptV.id)
                        .sideColor
                        .withOpacity(0.85));
              }
              list.add(TextSpan(text: check + " ", style: textStyle));
              i = -1000;
              m += formDecompose.length;
            }
          }
        }
        if (splitThesis[m].replaceAll(RegExp(r'[:;,.!?]'), "") == keys[j] &&
            i > -1) {
          if (mainMap[keys[j]] == "1") {
            textStyle = TextStyle(
                backgroundColor: provider.tree
                    .firstWhere((a) => a.id == conceptU.id)
                    .sideColor
                    .withOpacity(0.85));
          } else if (mainMap[keys[j]] == "2") {
            textStyle = TextStyle(
                backgroundColor: provider.tree
                    .firstWhere((a) => a.id == conceptV.id)
                    .sideColor
                    .withOpacity(0.85));
          }
          list.add(TextSpan(text: splitThesis[m] + " ", style: textStyle));
          i = -1000;
        } else if (i == mainMap.length - 1) {
          list.add(TextSpan(text: splitThesis[m] + " "));
        }
        i++;
      }
    }

    return RichText(
        text: TextSpan(
            text: "", style: mainStyle, children: <TextSpan>[...list]));
  }

  @override
  Widget build(BuildContext context) {
    final type = thesis.type;
    final text = thesis.data;

    switch (type) {
      case ThesisType.essence:
        return Essence(formatingRichText);
      case ThesisType.definition:
        return Definition(formatingRichText);
      case ThesisType.democode:
        return Democode(text, languageName);
      case ThesisType.denotation:
        return Denotation(formatingRichText);
      case ThesisType.note:
        return Note(formatingRichText);
      case ThesisType.tag:
        return Tag(text);
      default:
        return SizedBox.shrink();
    }
  }
}
