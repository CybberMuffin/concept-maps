import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  Tag(this.tag);

  String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          child: Text(tag,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold))),
    );
  }
}
