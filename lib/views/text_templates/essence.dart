import 'package:flutter/material.dart';

class Essence extends StatelessWidget {
  Essence(this.essence);

  String essence;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 15),
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          Icon(Icons.brightness_1_rounded, size: 8, color: Colors.black),
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Text(
              essence,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          )
        ],
      ),
    );
  }
}
