import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String tag;

  Tag(this.tag);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((_) {
              return Colors.lightBlueAccent.withOpacity(0.2);
            }),
            padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>((_) {
              return EdgeInsets.only(right: 32, left: 32);
            }),
            textStyle: MaterialStateProperty.resolveWith<TextStyle>((_) {
              return TextStyle(color: Colors.white);
            }),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              );
            }),
          ),
          //highlightColor: Colors.deepPurpleAccent,
          onPressed: () {},
          child: Text(tag,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold))),
    );
  }
}
