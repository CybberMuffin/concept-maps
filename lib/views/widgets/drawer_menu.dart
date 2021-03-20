import 'package:concept_maps/views/concept_list.dart';
import 'package:concept_maps/views/force_directed.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainColor = Colors.blue;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: mainColor),
            child: Center(
              child: Text(
                "Concept maps",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
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
        ],
      ),
    );
  }
}
