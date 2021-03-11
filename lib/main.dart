import 'package:concept_maps/views/BottomPannel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:concept_maps/views/BottomMenu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Demo Media Query",
      theme: ThemeData(textTheme:
      GoogleFonts.montserratTextTheme(
        Theme.of(context).textTheme,
      ),
      ),
      home: BottomMenu(),
    );
  }
}

