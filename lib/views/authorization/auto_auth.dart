import 'dart:async';
import 'package:concept_maps/providers/user_provider.dart';
import 'package:concept_maps/services/auth_service.dart';
import 'package:concept_maps/services/preferences.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:concept_maps/views/authorization/login_screen.dart';
import 'package:concept_maps/views/course_main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutoAuth extends StatefulWidget {
  const AutoAuth({Key key}) : super(key: key);

  @override
  _AutoAuthState createState() => _AutoAuthState();
}

class _AutoAuthState extends State<AutoAuth> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await navigateAfterBuild();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: kBreezeColor),
    );
  }

  Future navigateAfterBuild() async {
    final result = await context.read<UserProvider>().authorizeSilently();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => result ? CourseMain() : LoginScreen()),
    );
  }
}
