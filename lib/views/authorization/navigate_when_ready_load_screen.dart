import 'dart:async';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:flutter/material.dart';

class NavigateWhenReadyLoadScreen extends StatefulWidget {
  final Future<void> Function(BuildContext context) callWhenReady;
  const NavigateWhenReadyLoadScreen({Key key, @required this.callWhenReady}) : super(key: key);

  @override
  _NavigateWhenReadyLoadScreenState createState() => _NavigateWhenReadyLoadScreenState();
}

class _NavigateWhenReadyLoadScreenState extends State<NavigateWhenReadyLoadScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.callWhenReady(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: kBreezeColor),
    );
  }
}
