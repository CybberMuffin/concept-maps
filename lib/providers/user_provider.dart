import 'dart:collection';

import 'package:concept_maps/models/courses/branch.dart';
import 'package:concept_maps/models/courses/course.dart';
import 'package:concept_maps/models/graph_entities/node.dart';
import 'package:concept_maps/models/graph_entities/vertice.dart';
import 'package:concept_maps/models/logs/user_log.dart';
import 'package:concept_maps/services/api_service.dart';
import 'package:concept_maps/services/auth_service.dart';
import 'package:concept_maps/services/preferences.dart';
import 'package:concept_maps/utils/app_colors.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _userId;
  List<Course> myCourses;
  List<UserLog> userLogs = [];
  UserLog currentLog; // log that is currently being logged
  Set<String> viewedConceptIds = <String>{};

  final stopwatch = Stopwatch(); // stopwatch for logging

  Future<bool> authorizeUser(String login, String password) async {
    final result = await AuthService.authorize(login, password);
    if (result?.isNotEmpty ?? false) {
      _userId = result;
      Preferences.saveUserId(_userId);
      Preferences.setMarkViewedConceptsFlag(false);
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
    if (_userId.isNotEmpty) {
      userLogs = await ApiService.fetchUserLogsById(_userId);
      saveViewedConceptIds();
    }
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

  Future<void> logConceptView({@required String lastTime}) async {
    if (currentLog != null) {
      stopwatch.stop();
      currentLog.lastTime = lastTime;
      currentLog.seconds =
          (stopwatch.elapsedMilliseconds / 1000).ceil().toString();
      await ApiService.logConceptView(log: currentLog);
      stopwatch.reset();
      saveLogLocally();
      currentLog = null;
    }
  }

  void startLoggingConcept(
      {@required String time, @required String contentId}) async {
    await logConceptView(lastTime: time);
    stopwatch.start();
    currentLog = UserLog();
    currentLog.userId = _userId;
    currentLog.contentId = contentId;
    currentLog.time = time;
    currentLog.contentType = 'concept';
  }

  void saveViewedConceptIds() {
    userLogs.forEach((log) {
      if (log.contentType == 'concept') {
        viewedConceptIds.add(log.contentId);
      }
    });
  }

  void saveLogLocally() {
    userLogs.add(currentLog);
    saveViewedConceptIds();
  }

  Map<Node, int> getStatistics(List<Node> currentMapConcepts) {
    Map<Node, int> statistics = {};

    // TODO: uncomment if you want statistic without unviewed concepts
    //List<Node> viewedConceptIdsFromCurrentMap = [];

    //save viewed concepts from current map
    /*viewedConceptIds.forEach((id) {
      currentMapConcepts.forEach((concept) {
        if (id == concept.id) {
          viewedConceptIdsFromCurrentMap.add(concept);
        }
      });
    });*/

    // TODO: change 'currentMapConcepts' to 'viewedConceptIdsFromCurrentMap' if you want statistic without unviewed concepts
    // calculate time spent on concepts and form statistics
    currentMapConcepts.forEach((concept) {
      int secondsSpentOnConcept = 0;
      List<UserLog> logsByConcept = getLogsByConceptId(concept.id);
      logsByConcept.forEach((log) {
        secondsSpentOnConcept += int.tryParse(log.seconds);
      });
      // if (secondsSpentOnConcept > 0) {
      statistics[concept] = secondsSpentOnConcept;
      // }
    });

    // sort statistics by time (by value)
    final sortedByTimeStatistic = Map.fromEntries(statistics.entries.toList()
      ..sort((e1, e2) => e1.value.compareTo(e2.value)));
    final reversedSortedByTimeStatistic = LinkedHashMap.fromEntries(
        sortedByTimeStatistic.entries.toList().reversed);

    return reversedSortedByTimeStatistic;
  }

  Map<Node, int> getTopFiveStatistics(Map<Node, int> statistics) {
    Map<Node, int> topFiveStatistics = {};
    int count = 0;
    statistics.forEach((key, value) {
      if (count < 5) {
        if (value > 0) {
          topFiveStatistics[key] = value;
          count++;
        }
      } else {
        return;
      }
    });
    return topFiveStatistics;
  }

  double getStatisticBarWidthPercentage(
      int maxTimeInSeconds, int currentTimeInSeconds) {
    if (maxTimeInSeconds > 0) {
      double statisticBarWidthPercentage =
          (currentTimeInSeconds * 100 / maxTimeInSeconds / 100);
      return statisticBarWidthPercentage;
    } else
      return 0;
  }

  Course getCourseByName(String name) => myCourses
      .singleWhere((element) => element.name == name, orElse: () => null);
}
