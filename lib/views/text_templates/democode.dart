import 'package:flutter/material.dart';
import 'package:syntax_highlighter/syntax_highlighter.dart';

class Democode extends StatefulWidget {
  Democode(this.democode);
  String democode;

  @override
  _DemocodeState createState() => _DemocodeState(this.democode);
}

class _DemocodeState extends State<Democode> {
  _DemocodeState(this.democode);

  String democode;

  @override
  Widget build(BuildContext context) {
    final SyntaxHighlighterStyle style =
        Theme.of(context).brightness == Brightness.dark
            ? SyntaxHighlighterStyle.darkThemeStyle()
            : SyntaxHighlighterStyle.lightThemeStyle();
    return Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        margin: EdgeInsets.only(bottom: 10),
        color: Colors.grey.shade50,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontFamily: 'monospace', fontSize: 16.0),
                    children: <TextSpan>[
                      DartSyntaxHighlighter(style).format(democode),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
