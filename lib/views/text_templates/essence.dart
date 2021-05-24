import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Essence extends StatelessWidget {
  final Function essence;

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
            child: essence(context, TextStyle(fontSize: 17, fontStyle: FontStyle.italic, color: Colors.black))
            //Text(
            //  essence,
//          //      style: GoogleFonts.montserrat(fontSize: 16, fontStyle: FontStyle.italic)
            //  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            //),
          )
        ],
      ),
    );
  }
}
