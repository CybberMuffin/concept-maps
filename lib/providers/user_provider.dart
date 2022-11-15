import 'package:concept_maps/models/courses/branch.dart';
import 'package:concept_maps/models/courses/course.dart';
import 'package:concept_maps/models/logs/user_log.dart';
import 'package:concept_maps/services/api_service.dart';
import 'package:concept_maps/services/auth_service.dart';
import 'package:concept_maps/services/preferences.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _userId;
  List<Course> myCourses;
  List<UserLog> userLogs = [];
  List<String> viewedConceptIds = [];

  Future<bool> authorizeUser(String login, String password) async {
    final result = await AuthService.authorize(login, password);
    if (result?.isNotEmpty ?? false) {
      _userId = result;
      Preferences.saveUserId(_userId);
    }

    return _userId != null;
  }

  Future<bool> authorizeSilently() async {
    final userId = await Preferences.getUserId();
    _userId = userId;
    return _userId != null;
  }

  void logOut() {
    _userId = null;
    Preferences.removeUserId();
  }

  Future<void> fetchCourses() async {
    myCourses ??= await ApiService.fetchCoursesByUserId(_userId);
  }

  Future<void> fetchCourseBranches(Course course) async {
    final index = myCourses.indexOf(course);
    if (myCourses[index].branches?.isEmpty ?? true) {
      final childrenBranches = <Branch>[];
      for (final name in course.nameBranches) {
        childrenBranches.add(await ApiService.fetchBranchChildren(name));
      }

      myCourses[index] = course.copyWith(branches: childrenBranches);
    }
  }

  Future<void> fetchUserLogs() async {
    userLogs = await ApiService.fetchUserLogsById(_userId);
    saveViewedConceptIds();
  }

  List<UserLog> getLogsByConceptId(String conceptId) {
    List<UserLog> currentConceptLogs = [];
    userLogs.forEach((log) {
      if (log.contentId == conceptId) {
        currentConceptLogs.add(log);
      }
    });
    return currentConceptLogs;
  }

  Future<void> logConceptView({
    @required String contentId,
    @required String time,
    @required int seconds,
    @required String lastTime,
  }) async {
    await ApiService.logConceptView(
      id: int.tryParse(_userId),
      contentId: contentId,
      time: time,
      seconds: seconds,
      lastTime: lastTime,
    );
  }

  void saveViewedConceptIds() {
    userLogs.forEach((log) {
      if (log.contentType == 'concept') {
        viewedConceptIds.add(log.contentId);
      }
    });
  }

  void markConceptAsViewed() {}

  Course getCourseByName(String name) => myCourses
      .singleWhere((element) => element.name == name, orElse: () => null);
}
