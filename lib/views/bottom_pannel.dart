import 'package:concept_maps/models/general_entities/thesis.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/views/text_templates/definition.dart';
import 'package:concept_maps/views/text_templates/democode.dart';
import 'package:concept_maps/views/text_templates/denotation.dart';
import 'package:concept_maps/views/text_templates/essence.dart';
import 'package:concept_maps/views/text_templates/note.dart';
import 'package:concept_maps/views/text_templates/tag.dart';
import 'package:concept_maps/views/text_templates/theses_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BottomPannel extends StatefulWidget {
  @override
  _BottomPannelState createState() => _BottomPannelState();
}

class _BottomPannelState extends State<BottomPannel> {
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  provider.focusTitle,
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              margin: EdgeInsets.only(bottom: 5),
              child: Divider(
                color: Colors.black,
                height: 20,
                thickness: 4.3,
                endIndent: 275,
              ),
            ),
            FutureBuilder <List<Thesis>>(
                future: provider.fetchThesesByConceptFork(
                  int.parse(provider.focusNode.id),
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {

                    final theses = snapshot.data;
                    if(!provider.isEdgeActive){
                      return Column(
                        children: theses
                            .map<Widget>(
                              (thesis) => ThesisViewBuilder(
                            thesis: thesis,
                          ),
                        ).toList(),
                      );
                    }else {
                      int k = -1;
                      int difId = theses[0].conceptId;
                      theses.asMap().forEach((key, value) {
                        if(value.conceptId != difId)
                        {
                          k = key;
                          difId = value.conceptId;
                        }
                      });
                      final concept1 = provider.currentMap.concepts.firstWhere((a) => a.id == provider.focusEdge.u.id);
                      final concept2 = provider.currentMap.concepts.firstWhere((a) => a.id == provider.focusEdge.v.id);
                      List<Thesis> thesesU = [];
                      List<Thesis> thesesV = [];
                      if(k == -1){
                        if(difId.toString() == concept1.id){
                          thesesV = theses;
                        }else if(difId.toString() == concept2.id){
                          thesesU = theses;
                        }
                      }else{
                        thesesV = List.from(theses.sublist(0, k));
                        thesesU = List.from(theses.sublist(k, theses.length));
                      }
                      final uTitle = provider.focusEdge.u.title;
                      final vTitle = provider.focusEdge.v.title;
                      print(concept1.concept);
                      print(concept2.concept);
                      return Column(
                          children: [
                          Align(
                          alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              margin: EdgeInsets.only(bottom: 5),
                              child: Text(
                                thesesU.isEmpty? "" : uTitle+" in "+vTitle+" theses",
                                style: GoogleFonts.montserrat(
                                 fontSize: 18,
                                 fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                            ...thesesU.map<Widget>(
                                  (thesis) => ThesisViewBuilder(
                                thesis: thesis, edge: provider.focusEdge,
                              ),
                            ).toList(),
                            Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              margin: EdgeInsets.only(bottom: 5),
                              child: Text(
                                thesesV.isEmpty? "" : vTitle+" in "+uTitle+" theses",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),),
                              ),
                            ),
                            ...thesesV.map<Widget>(
                                  (thesis) => ThesisViewBuilder(
                                thesis: thesis, edge: provider.focusEdge,
                              ),
                            ).toList()

                          ]
                      );
                    }
                  }

                  if (snapshot.hasError) {
                    return Container();
                    // return Text(
                    //   snapshot.error.toString(),
                    //   style: TextStyle(color: Colors.red),
                    // );
                  }

                  return CircularProgressIndicator();
                }),
          ],
        ),
      ),
    );
  }
}
