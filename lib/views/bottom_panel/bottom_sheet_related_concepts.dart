import 'package:auto_size_text/auto_size_text.dart';
import 'package:concept_maps/models/dedactic_relations_entities/concept_in_theses.dart';
import 'package:concept_maps/models/general_entities/concept.dart';
import 'package:concept_maps/models/general_entities/thesis.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/views/widgets/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:concept_maps/views/text_templates/theses_builder.dart';

class RelatedConcepts extends StatefulWidget {
  @override
  _RelatedConceptsState createState() => _RelatedConceptsState();
}

class _RelatedConceptsState extends State<RelatedConcepts> {
  List<Concept> concepts = [];
  List<bool> dots = [];
  List<int> compareCinT = [];
  ConceptInTheses currentConceptsInTheses;
  ConceptInTheses nextConceptsInTheses;
  int conceptIndex;
  List<Thesis> thesis = [];
  String thesisData;

  calculateDots() {
    for (int i = 0; i < concepts.length; i++) {
      if (i == conceptIndex || i == conceptIndex - 1 || i == conceptIndex + 1) {
        dots.add(true);
      } else {
        dots.add(false);
      }
    }
  }

  Future<ConceptInTheses> fillCurrentCinT() async {
    context
        .read<AppProvider>()
        .fetchConceptInTheses(
            int.tryParse(context.read<AppProvider>().focusNode.id))
        .then((value) => currentConceptsInTheses = value);

    return currentConceptsInTheses;
  }

  Future<ConceptInTheses> fillNextCinT() async {
    context
        .read<AppProvider>()
        .fetchConceptInTheses(int.tryParse(concepts[conceptIndex].id))
        .then((value) => nextConceptsInTheses = value)
        .then((_) => compare());

    return nextConceptsInTheses;
  }

  void compare() {
    currentConceptsInTheses.innerReferences.forEach((a) {
      nextConceptsInTheses.innerReferences.forEach((b) {
        if (a.thesisId == b.thesisId) {
          if (!compareCinT.contains(a.thesisId)) {
            compareCinT.add(a.thesisId);
          }
        }
      });
      nextConceptsInTheses.outerReferences.forEach((b) {
        if (a.thesisId == b.thesisId) {
          if (!compareCinT.contains(a.thesisId)) {
            compareCinT.add(a.thesisId);
          }
        }
      });
    });
    currentConceptsInTheses.outerReferences.forEach((a) {
      nextConceptsInTheses.outerReferences.forEach((b) {
        if (a.thesisId == b.thesisId) {
          if (!compareCinT.contains(a.thesisId)) {
            compareCinT.add(a.thesisId);
          }
        }
      });
      nextConceptsInTheses.innerReferences.forEach((b) {
        if (a.thesisId == b.thesisId) {
          if (!compareCinT.contains(a.thesisId)) {
            compareCinT.add(a.thesisId);
          }
        }
      });
    });
  }

  Future<String> getThesis() async {
    compareCinT.forEach((element) {
      print(element);
    });
    context
        .read<AppProvider>()
        .fetchTheses(compareCinT)
        .then((value) => thesis = value)
        .then((value) => value.forEach((element) {
              setState(() {
                print(thesisData);
                thesisData += element.data + "\n";
              });
            }));

    return thesisData;
  }

  Future<String> parseFuture() async {
    await fillCurrentCinT();
    await fillNextCinT();
    await getThesis();

    return thesisData;
  }

  parseDidacticAfter() {
    FutureBuilder(
      future: context
          .read<AppProvider>()
          .fetchConceptsDidacticAfter(
              int.tryParse(context.read<AppProvider>().focusNode.id))
          .then((a) => setState(() {
                a.forEach((element) {
                  if (context.read<AppProvider>().focusNode.id != element.id) {
                    concepts.add(element);
                  }
                });
                parseFuture();
                calculateDots();
              })),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void initState() {
    conceptIndex = 0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    concepts = [];
    thesisData = "";
    parseDidacticAfter();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = context.read<AppProvider>();
    return Container(
      margin:
          EdgeInsets.only(left: 0, right: 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: FutureBuilder <List<Thesis>>(
                      future: provider.fetchEdgeTheses(int.parse(provider.focusNode.id), concepts[conceptIndex].iid),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {

                          final theses = snapshot.data;
                            int k = -1;
                            int difId = theses[0].conceptId;
                            theses.asMap().forEach((key, value) {
                              if(value.conceptId != difId)
                              {
                                k = key;
                                difId = value.conceptId;
                              }
                            });
                            final concept1 = provider.currentMap.concepts.firstWhere((a) => a.id == provider.focusNode.id);
                            final concept2 = provider.currentMap.concepts.firstWhere((a) => a.id == concepts[conceptIndex].id);
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
                            final uTitle = concept1.concept;
                            final vTitle = concept2.concept;
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
                                      thesis: thesis, conceptU: concept1, conceptV: concept2,
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
                                      thesis: thesis, conceptU: concept1, conceptV: concept2,
                                    ),
                                  ).toList()

                                ]
                            );

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
                  ),
              height: (size.height - 115) * 0.47,
            ),
            Container(
              child: RadiantGradientMask(
                color1: provider.tree.firstWhere((a) => a.id == concepts[conceptIndex].id).sideColor,
                color2: provider.tree.firstWhere((a) => a.id == provider.focusNode.id).sideColor,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 45,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              //constraints: BoxConstraints(maxHeight: (size.height - 115) / 2),
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      constraints: BoxConstraints(maxWidth: size.width * 0.4),
                      padding: EdgeInsets.only(right: size.width * 0.02),
                      //margin: EdgeInsets.only(top: size.height * 0.063),
                      //color: Colors.red,
                      child: AutoSizeText(
                        context.read<AppProvider>().focusNode.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 3,
                      )),

                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          provider.tree.firstWhere((a) => a.id == concepts[conceptIndex].id).sideColor,
                          provider.tree.firstWhere((a) => a.id == provider.focusNode.id).sideColor,
                        ],
                      )),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: size.width * 0.4,
                        maxHeight: (size.height - 115) * 0.31),
                    padding: EdgeInsets.only(left: size.width * 0.02),
                    child: PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: concepts.length,
                      controller: PageController(viewportFraction: 0.4),
                      onPageChanged: (int index) => setState(() {
                        conceptIndex = index;
                        thesisData = "";
                        compareCinT.clear();
                        parseFuture();
                        if (dots.isNotEmpty) {
                          dots.clear();
                          calculateDots();
                        }
                      }),
                      itemBuilder: (_, i) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              child: AutoSizeText(
                            concepts[i].concept,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: (i == conceptIndex)
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                            maxLines: 3,
                          )),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: size.height * 0.03),
                child: DotsIndicator(dots)),
          ],
        ),
      ),
    );
  }
}

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({this.child, this.color1, this.color2});
  final Widget child;
  final Color color1;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => RadialGradient(
        center: Alignment.center,
        radius: 0.2,
        colors: [color1, color2],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
