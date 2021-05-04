import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RelatedConcepts extends StatefulWidget {
  @override
  _RelatedConceptsState createState() => _RelatedConceptsState();
}

class _RelatedConceptsState extends State<RelatedConcepts> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin:
          EdgeInsets.only(left: size.width * 0.04, right: size.width * 0.04),
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
                    padding: EdgeInsets.only(right: size.width * 0.015),
                    //color: Colors.red,
                    child: AutoSizeText(
                      "Basic layout operations: Setting background color",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  constraints: BoxConstraints(maxWidth: size.width * 0.4),
                  padding: EdgeInsets.only(left: size.width * 0.015),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.only(bottom: size.width * 0.02),
                          child: AutoSizeText(
                            "Basic layout operations: Setting background color",
                            style: TextStyle(fontSize: 17),
                            maxLines: 3,
                          )),
                      Container(
                          padding: EdgeInsets.only(bottom: size.width * 0.02),
                          child: AutoSizeText(
                            "Generics",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                            maxLines: 3,
                          )),
                      Container(
                          padding: EdgeInsets.only(bottom: size.width * 0.02),
                          child: AutoSizeText(
                            "Flutter for web developers",
                            style: TextStyle(fontSize: 17),
                            maxLines: 3,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
