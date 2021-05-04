import 'package:flutter/material.dart';

class Definition extends StatelessWidget {
  Definition(this.definition);

  String definition;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        margin: EdgeInsets.only(bottom: 10),
        child: Text(
          definition,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
