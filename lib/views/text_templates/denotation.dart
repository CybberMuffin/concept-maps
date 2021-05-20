import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Denotation extends StatelessWidget {
  final Function denotation;

  Denotation(this.denotation);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 5),
              width: size.width * 0.04,
              child: VerticalDivider(
                color: Colors.grey.shade300,
                thickness: 1.5,
              ),
            ),
            Container(
              width: size.width - size.width * 0.04,
              padding: const EdgeInsets.only(left: 5, right: 15),
              margin: EdgeInsets.only(bottom: 10),
              child: denotation(context, fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black)
            ),
          ],
        ),
      ),
    );
  }
}
