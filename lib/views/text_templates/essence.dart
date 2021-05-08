import 'package:flutter/material.dart';

class Essence extends StatelessWidget {
  final String essence;

  Essence(this.essence);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 10),
      padding: const EdgeInsets.only(left: 10, right: 15),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Icon(Icons.brightness_1_rounded, size: 8, color: Colors.black),
          Container(
            margin: EdgeInsets.only(left: 15),
            width: size.width * 0.85,
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
