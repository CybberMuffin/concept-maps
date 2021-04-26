import 'package:concept_maps/providers/app_provider.dart';
import 'package:concept_maps/views/text_templates/definition.dart';
import 'package:concept_maps/views/text_templates/democode.dart';
import 'package:concept_maps/views/text_templates/essence.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BottomPannel extends StatefulWidget {
  @override
  _BottomPannelState createState() => _BottomPannelState();
}

class _BottomPannelState extends State<BottomPannel> {
  Widget build(BuildContext context) {
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
                  context.read<AppProvider>().focusNode.title,
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
            Definition(
                "Lorem ipsum dolor sit amet, consecte adip iscing elit, sed do eiusmod."),
            Essence("Lorem ipsum dolor."),
            Essence("Tet adip iscing elit sit."),
            Essence("Eiusmod tempor incididunt."),
            Definition(
              "Lorem ipsum dolor sit amet, consec tet adip iscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
            ),
            Democode(
                "Import 'package:flutter/material.dart';\n\nclass MyAppBar extends StatelessWidget {\n  MyAppBar({this.title});\n\n  // Fields in a Widget subclass are always marked \"final\".\n\n  final Widget title;\n\n  @override\n  Widget build(BuildContext context) {\n    return Container(\n      height: 56.0, // in logical pixels\n      padding: const EdgeInsets.symmetric(horizontal: 8.0),\n      decoration: BoxDecoration(color: Colors.blue[500]),\n      // Row is a horizontal, linear layout.\n      child: Row(\n        // <Widget> is the type of items in the list.\n        children: <Widget>[\n          IconButton(\n            icon: Icon(Icons.menu),\n            tooltip: 'Navigation menu',\n            onPressed: null, // null disables the button\n          ),\n          // Expanded expands its child to fill the available space.\n          Expanded(\n            child: title,\n          ),\n          IconButton(\n            icon: Icon(Icons.search),\n            tooltip: 'Search',\n            onPressed: null,\n          ),\n        ],\n      ),\n    );\n  }\n}\n\nclass MyScaffold extends StatelessWidget {\n  @override\n  Widget build(BuildContext context) {\n    // Material is a conceptual piece of paper on which the UI appears.\n    return Material(\n      // Column is a vertical, linear layout.\n      child: Column(\n        children: <Widget>[\n          MyAppBar(\n            title: Text(\n              'Example title',\n              style: Theme.of(context).primaryTextTheme.title,\n            ),\n          ),\n          Expanded(\n            child: Center(\n              child: Text('Hello, world!'),\n            ),\n          ),\n        ],\n      ),\n    );\n  }\n}\n\nvoid main() {\n  runApp(MaterialApp(\n    title: 'My app', // used by the OS task switcher\n    home: MyScaffold(),\n  ));\n}"),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              margin: EdgeInsets.only(bottom: 5),
              child: Row(children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: FlatButton(
                      color: Colors.lightBlueAccent.withOpacity(0.2),
                      padding: EdgeInsets.only(right: 32, left: 32),
                      //highlightColor: Colors.deepPurpleAccent,
                      onPressed: () {},
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Text("TAG_01",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold))),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: FlatButton(
                      color: Colors.lightBlueAccent.withOpacity(0.2),
                      padding: EdgeInsets.only(right: 32, left: 32),
                      //highlightColor: Colors.deepPurpleAccent,
                      onPressed: () {},
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Text("TAG_02",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold))),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: FlatButton(
                      color: Colors.lightBlueAccent.withOpacity(0.2),
                      padding: EdgeInsets.only(right: 32, left: 32),
                      //highlightColor: Colors.deepPurpleAccent,
                      onPressed: () {},
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Text("TAG_03",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold))),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
