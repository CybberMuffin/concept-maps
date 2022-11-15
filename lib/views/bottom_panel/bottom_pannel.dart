import 'package:concept_maps/models/general_entities/thesis.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/providers/user_provider.dart';
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

    return provider.focusTitle.isNotEmpty
        ? Container(
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
                      height: 16,
                      thickness: 4.3,
                      endIndent: 275,
                    ),
                  ),
                  FutureBuilder<List<Thesis>>(
                      future: provider.fetchThesesByConceptFork(
                        int.tryParse(provider.focusNode.id),
                        context
                            .read<UserProvider>()
                            .getLogsByConceptId(provider.focusNode.id),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final theses = snapshot.data;
                          if (!provider.isEdgeActive) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  provider.currentConcept.timeSpent != 0
                                      ? Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              15, 0, 15, 10),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'Time spent on concept: ${provider.currentConcept.timeSpent} seconds',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  ...theses
                                      .map<Widget>(
                                        (thesis) => ThesisViewBuilder(
                                          thesis: thesis,
                                          languageName:
                                              provider.currentMap.field,
                                        ),
                                      )
                                      .toList(),
                                ]);
                          } else {
                            int k = -1;
                            int difId = theses[0].conceptId;
                            theses.asMap().forEach((key, value) {
                              if (value.conceptId != difId) {
                                k = key;
                                difId = value.conceptId;
                              }
                            });
                            final concept1 = provider.currentMap.concepts
                                .firstWhere(
                                    (a) => a.id == provider.focusEdge.u.id);
                            final concept2 = provider.currentMap.concepts
                                .firstWhere(
                                    (a) => a.id == provider.focusEdge.v.id);
                            List<Thesis> thesesU = [];
                            List<Thesis> thesesV = [];
                            if (k == -1) {
                              if (difId.toString() == concept1.id) {
                                thesesV = theses;
                              } else if (difId.toString() == concept2.id) {
                                thesesU = theses;
                              }
                            } else {
                              thesesV = List.from(theses.sublist(0, k));
                              thesesU =
                                  List.from(theses.sublist(k, theses.length));
                            }
                            final uTitle = provider.focusEdge.u.title;
                            final vTitle = provider.focusEdge.v.title;
                            return Column(children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    thesesU.isEmpty
                                        ? ""
                                        : uTitle + " in " + vTitle + " theses",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              ...thesesU
                                  .map<Widget>(
                                    (thesis) => ThesisViewBuilder(
                                      thesis: thesis,
                                      conceptU: concept1,
                                      conceptV: concept2,
                                      languageName: provider.currentMap.field,
                                    ),
                                  )
                                  .toList(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    thesesV.isEmpty
                                        ? ""
                                        : vTitle + " in " + uTitle + " theses",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              ...thesesV
                                  .map<Widget>(
                                    (thesis) => ThesisViewBuilder(
                                      thesis: thesis,
                                      conceptU: concept1,
                                      conceptV: concept2,
                                      languageName: provider.currentMap.field,
                                    ),
                                  )
                                  .toList()
                            ]);
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
          )
        : Center(
            child: Text(
              'No node was selected',
              style: TextStyle(fontSize: 18),
            ),
          );
  }
}
