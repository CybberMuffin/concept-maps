import 'package:concept_maps/views/ConceptList.dart';
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
            // onTap: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (BuildContext context) => ConceptList(),
            //     )),
          ),
          ListTile(
            leading: Icon(
              Icons.list_alt,
              color: mainColor,
            ),
            title: Text("List"),
          ),
        ],
      ),
    );
  }
}
