import 'package:concept_maps/models/courses/branch.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class LectureContentScreen extends StatefulWidget {
  final Branch branch;
  LectureContentScreen({Key key, @required this.branch}) : super(key: key);

  @override
  _LectureContentScreenState createState() => _LectureContentScreenState();
}

class _LectureContentScreenState extends State<LectureContentScreen> {
  Branch get _branch => widget.branch;

  Widget get appBar => NewGradientAppBar(
        title: Text(_branch.caption),
        centerTitle: true,
        automaticallyImplyLeading: true,
        gradient: LinearGradient(colors: [kPurpleColor, kBreezeColor]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Html(
              shrinkWrap: true,
              data: _branch.text ?? '',
            ),
          ),
        ),
      ),
    );
  }
}
