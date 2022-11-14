import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

class Democode extends StatefulWidget {
  final String democode;
  final String languageName;
  Democode(this.democode, this.languageName);

  @override
  _DemocodeState createState() => _DemocodeState();
}

class _DemocodeState extends State<Democode> {
  _DemocodeState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: HighlightView(
                widget.democode,
                language: widget.languageName,
                theme: githubTheme,
                padding: const EdgeInsets.all(8),
                textStyle:
                    const TextStyle(fontFamily: 'monospace', fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
