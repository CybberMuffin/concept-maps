import 'package:flutter/material.dart';

class Definition extends StatelessWidget {
  final Function definition;

  Definition(this.definition);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        margin: EdgeInsets.only(bottom: 10),
        child: definition(context, TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black))
      ),
    );
  }
}
