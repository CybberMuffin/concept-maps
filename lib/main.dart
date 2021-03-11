
import 'package:flutter/material.dart';
import 'views/CourseMain.dart';

main() {
  runApp(MaterialApp(home: App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CourseMain()
      );
  }
}
