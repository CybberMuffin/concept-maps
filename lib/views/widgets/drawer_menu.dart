import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/views/concept_list.dart';
import 'package:concept_maps/views/force_directed.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final String title;
  const DrawerMenu({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainColor = kPurpleColor;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: mainColor),
            child: Center(
              child: Text(
                title ?? "Concept maps",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.map,
              color: mainColor,
            ),
            title: Text("Map"),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ForceDirected(),
              ),
              (_) => false,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.list_alt,
              color: mainColor,
            ),
            title: Text("List"),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ConceptList(),
              ),
              (_) => false,
            ),
          ),
          /*   ListTile(
            leading: Icon(
              Icons.call_made,
              color: mainColor,
            ),
            title: Text("Liner Map"),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LinerGraph(),
              ),
                  (_) => false,
            ),
          ), */
        ],
      ),
    );
  }
}
