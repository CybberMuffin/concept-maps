import 'dart:convert';
import 'package:concept_maps/constants/general.dart';
import 'package:concept_maps/models/courses/branch.dart';
import 'package:concept_maps/models/courses/course.dart';
import 'package:concept_maps/models/dedactic_relations_entities/concept_in_theses.dart';
import 'package:concept_maps/models/general_entities/concept.dart';
import 'package:concept_maps/models/general_entities/thesis.dart';
import 'package:concept_maps/models/graph_entities/map_model.dart';
import 'package:concept_maps/models/logs/user_log.dart';
import 'package:concept_maps/utils/course_key_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class ApiService {
  static String get _api => '$hostUrl/api';
  static String get _logApi => '$hostUrl/log/api';

  static Future<MapModel> fetchConceptRelations(String field) async {
    final relationsUrl = Uri.parse('$_api/branch/$field/concepts/relations');
    final conceptsUrl = Uri.parse('$_api/branch/$field/concepts');
    final headerUrl = Uri.parse('$_api/CinH/$field');

    final response = await Future.wait<http.Response>(
      [
        http.get(relationsUrl),
        http.get(conceptsUrl),
        http.get(headerUrl),
      ],
    );

    final relationsResponse = response.first;
    final conceptsResponse = response[1];
    final headerResponse = response[2];

    if (relationsResponse.statusCode == 200 &&
        conceptsResponse.statusCode == 200) {
      final List relationsResult = jsonDecode(relationsResponse.body);
      final List conceptsResult = jsonDecode(conceptsResponse.body);
      final List headerResult = jsonDecode(headerResponse.body);

      return MapModel.fromMap(
          field, relationsResult, conceptsResult, headerResult);
    }

    throw Exception("Error occurred during fetch of map model");
  }

  static Future<List<MapModel>> fetchBranches() async {
    final List<MapModel> maps = await Future.wait<MapModel>(
      CourseListInfo.courseKeyList
          //.sublist(0, 6)
          .map<Future<MapModel>>((key) => fetchConceptRelations(key))
          .toList(),
    );

    return maps;
  }

  static Future<ConceptInTheses> fecthConceptsInTheses(int conceptId) async {
    assert(conceptId != null);
    final url = Uri.parse('$hostUrl/api/concept/$conceptId/CinT');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return ConceptInTheses.fromMap(result, conceptId);
    }

    throw Exception("Error occurred during fetch of concepts in theses");
  }

  static Future<List<Concept>> fetchConceptsDidacticBefore(
      int conceptId) async {
    assert(conceptId != null);
    final url = Uri.parse('$hostUrl/api/concept/$conceptId/didactic/before');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return List<Concept>.from(
        result?.map((x) => Concept.fromJson(x)),
      );
    }

    throw Exception(
        "Error occurred during fetch of concepts in didactic before");
  }

  static Future<List<Concept>> fetchConceptsDidacticAfter(int conceptId) async {
    assert(conceptId != null);
    final url = Uri.parse('$hostUrl/api/concept/$conceptId/didactic/after');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return List<Concept>.from(
        result?.map((x) => Concept.fromJson(x)),
      );
    }

    throw Exception(
        "Error occurred during fetch of concepts in didactic after");
  }

  static Future<List<Thesis>> fetchThesesByConceptId(int conceptId) async {
    assert(conceptId != null);
    final url = Uri.parse('$hostUrl/api/concept/$conceptId/thesis');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return List<Thesis>.from(
        result?.map((x) => Thesis.fromMap(x)),
      );
    }

    throw Exception("Error occurred during fetch of theses by concept id");
  }

  static Future<List<Thesis>> fetchTheses(List<int> thesisIds) async {
    assert(thesisIds != null);
    assert(thesisIds.isNotEmpty);

    final thesisIdsStr = thesisIds.join(",");
    final url = Uri.parse('$_api/thesis/$thesisIdsStr');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return List<Thesis>.from(
        result?.map((x) => Thesis.fromMap(x)),
      );
    }

    throw Exception("Error occurred during fetch of selected theses");
  }

  static Future<List<Course>> fetchCoursesByUserId(String userId) async {
    assert(userId?.isNotEmpty ?? false);
    final url = Uri.parse('$_logApi/user/$userId/details');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final courseQueries = result[kCourses]
          .map<Future<Course>>((course) => _fetchCourseDetails(course[kCourse]))
          .toList();

      return await Future.wait(courseQueries);
    }

    throw Exception("Error occurred during fetch of user courses");
  }

  static Future<Branch> fetchBranchChildren(String branchName) async {
    assert(branchName?.isNotEmpty ?? false);
    final url = Uri.parse('$_api/branch/$branchName/children');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final chlildrenResult = jsonDecode(response.body) as List;
      final branch = await fetchBranchInfo(branchName);

      if (chlildrenResult.isNotEmpty) {
        final childrenBranches = await Future.wait(chlildrenResult
            .map<Future<Branch>>(
                (branchInfo) => fetchBranchChildren(branchInfo['view']))
            .toList());
        return branch.copyWith(children: childrenBranches);
      }

      return branch;
    }

    throw Exception("Error occurred during fetch of $branchName children");
  }

  static Future<Branch> fetchBranchInfo(String branchName) async {
    assert(branchName?.isNotEmpty ?? false);
    final url = Uri.parse('$_api/branch/$branchName/view');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Branch.fromJson(response.body);
    }

    throw Exception("Error occurred during fetch of $branchName info");
  }

  static Future<Course> _fetchCourseDetails(String course) async {
    assert(course?.isNotEmpty ?? false);
    final url = Uri.parse('$_logApi/course/$course');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      return Course(
        name: result[kCourse][kCourse] as String,
        caption: result[kCourse][kCaption] as String,
        nameBranches:
            List<String>.from(result[kBranches]?.map((x) => x as String)),
      );
    }
    throw Exception("Error occurred during fetch of $course Course Details");
  }

  static Future<List<UserLog>> fetchUserLogsById(String id) async {
    assert(id?.isNotEmpty ?? false);
    final url = Uri.parse('$_logApi/user/$id');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List<UserLog> userLogs = [];
      result.forEach((element) {
        userLogs.add(UserLog.fromJson(element));
      });
      return userLogs;
    }
    throw Exception("Error occurred during fetch of user logs: id $id");
  }

  static Future logConceptView({
    @required int id,
    @required String contentId,
    @required int time,
    @required int seconds,
    @required int lastTime,
  }) async {
    assert(id != null ?? false);
    assert(contentId.isNotEmpty ?? false);
    assert(time != null ?? false);
    assert(seconds != null ?? false);
    assert(lastTime != null ?? false);
    final url = Uri.parse('$_logApi/log/concept');
    final body = jsonEncode(<String, dynamic>{
      'userId': id,
      'contentId': contentId,
      'time': time,
      'seconds': seconds,
      'lastTime': lastTime,
    });
    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      print('Action logged.');
    }
    throw Exception("Error occurred during fetch of user logs: id $id");
  }
}
