import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RelatedConcepts extends StatefulWidget {
  @override
  _RelatedConceptsState createState() => _RelatedConceptsState();
}

class _RelatedConceptsState extends State<RelatedConcepts> {
  List<Widget> concepts = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final size = MediaQuery.of(context).size;
    concepts = [
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
            //padding: EdgeInsets.only(bottom: size.height * 0.02),
            child: AutoSizeText(
          "Basic layout operations: Setting background color",
          style: TextStyle(fontSize: 17),
          maxLines: 3,
        )),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
            //padding: EdgeInsets.only(bottom: size.height * 0.02),
            child: AutoSizeText(
          "Generics",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          maxLines: 3,
        )),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
            //padding: EdgeInsets.only(bottom: size.height * 0.02),
            child: AutoSizeText(
          "Flutter for web developers jjjjjjjjjjjjjjjjjjjj hdg",
          style: TextStyle(fontSize: 17),
          maxLines: 3,
        )),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
            //padding: EdgeInsets.only(bottom: size.height * 0.02),
            child: AutoSizeText(
          "Flutter for web developers jjjjjjjjjjjj",
          style: TextStyle(fontSize: 17),
          maxLines: 3,
        )),
      ),
    ];
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
              height: (size.height - 115) * 0.6,
            ),
            Container(
              //constraints: BoxConstraints(maxHeight: (size.height - 115) / 2),
              child: Row(
                children: [
                  Container(
                      constraints: BoxConstraints(maxWidth: size.width * 0.4),
                      padding: EdgeInsets.only(right: size.width * 0.02),
                      //color: Colors.red,
                      child: AutoSizeText(
                        "Basic layout operations: Setting background color",
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
                      /*onPageChanged: (int index) =>
                          setState(() => _index = index), */
                      itemBuilder: (_, i) {
                        return concepts[i];
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
