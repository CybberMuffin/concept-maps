import 'package:concept_maps/models/enums/thesis_type.dart';
import 'package:concept_maps/models/general_entities/concept.dart';
import 'package:concept_maps/models/general_entities/thesis.dart';
import 'package:concept_maps/models/graph_entities/edge.dart';
import 'package:concept_maps/views/text_templates/definition.dart';
import 'package:concept_maps/views/text_templates/democode.dart';
import 'package:concept_maps/views/text_templates/denotation.dart';
import 'package:concept_maps/views/text_templates/essence.dart';
import 'package:concept_maps/views/text_templates/note.dart';
import 'package:concept_maps/views/text_templates/tag.dart';
import 'package:flutter/material.dart';

class ThesisViewBuilder extends StatelessWidget {
  final Thesis thesis;
  Edge edge;
  ThesisViewBuilder({Key key, this.thesis, this.edge}) : super(key: key);

  Widget formatingRichText(BuildContext context, TextStyle mainStyle){

    if(edge == null){
      return RichText(
          text: TextSpan(
            text: thesis.data,
            style: mainStyle,
          )
      );
    }
    List<InlineSpan> list = [];

    String c1s = edge.u.forms;
    String c2s = edge.v.forms;
    List<String> c1 = c1s.split("; ");
    List<String> c2 = c2s.split("; ");

    c1.add(edge.u.title);
    c2.add(edge.v.title);

    Map<String, String> mainMap = {};

    c1.forEach((element) {
      mainMap[element] = "1";
    });
    c2.forEach((element) {
      mainMap[element] = "2";
    });

    List<String> splitThesis = thesis.data.split(" ");
    List<String> keys = mainMap.keys.toList();

    print(mainMap);
    for(int m = 0; m < splitThesis.length; m++){
      int i = 0;
      for(int j = 0; j < mainMap.length; j++){
        TextStyle textStyle;
        if(splitThesis[m].replaceAll(RegExp(r'[:;,.!?\n]'), "") == keys[j]){
          print("2");
          if(mainMap[keys[j]] == "1"){
            textStyle = TextStyle(backgroundColor: edge.u.sideColor.withOpacity(0.85));
          }
          else if(mainMap[keys[j]] == "2"){
            textStyle = TextStyle(backgroundColor: edge.v.sideColor.withOpacity(0.85));
          }
          list.add(TextSpan(text: splitThesis[m] + " ", style: textStyle));
          i = -1000;
        }else if(i == mainMap.length - 1){
          list.add(TextSpan(text: splitThesis[m]+" "));
        }
        i++;
      }
    }
    thesis.data.split(" ").forEach((b) {

    });

    //concept2.forms.split("; ").forEach((element) {
    //  list.add(TextSpan(text: element, style: TextStyle(backgroundColor: Colors.amberAccent)));
    //});

    return RichText(
        text: TextSpan(
          text: "",
          style: mainStyle,
          children: <TextSpan>[
            ...list
          ]
        )
    );

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
        return Democode(text);
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
