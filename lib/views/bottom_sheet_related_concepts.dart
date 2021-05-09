import 'package:auto_size_text/auto_size_text.dart';
import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/views/widgets/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RelatedConcepts extends StatefulWidget {
  @override
  _RelatedConceptsState createState() => _RelatedConceptsState();
}

class _RelatedConceptsState extends State<RelatedConcepts> {
  List<String> concepts = [];
  List<bool> dots = [];
  int conceptIndex;

  calculateDots() {
    for (int i = 0; i < concepts.length; i++) {
      if (i == conceptIndex || i == conceptIndex - 1 || i == conceptIndex + 1) {
        dots.add(true);
      } else {
        dots.add(false);
      }
    }
    ;
  }

  parseDidacticAfter() {
    FutureBuilder(
      future: context
          .read<AppProvider>()
          .fetchConceptsDidacticAfter(
              int.tryParse(context.read<AppProvider>().focusNode.id))
          .then((a) => setState(() {
                concepts.clear();
                a.forEach((element) {
                  concepts.add(element.concept);
                });
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
    concepts = [""];
    parseDidacticAfter();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin:
          EdgeInsets.only(left: size.width * 0.04, right: size.width * 0.04),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              color: Colors.red,
              //margin: EdgeInsets.only(bottom: 15),
              height: (size.height - 115) * 0.47,
            ),
            Container(
              child: RadiantGradientMask(
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
                          Colors.pink.shade400,
                          Colors.blueAccent,
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
                            concepts[i],
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
  RadiantGradientMask({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => RadialGradient(
        center: Alignment.center,
        radius: 0.2,
        colors: [Colors.pink.shade400, Colors.blueAccent],
        tileMode: TileMode.mirror,
      ).createShader(bounds),
      child: child,
    );
  }
}
