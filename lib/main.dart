import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/CourseMain.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My Demo Media Query",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: CourseMain(), //change to BottomMenu() here if u need to
    );
  }
}
