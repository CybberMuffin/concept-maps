import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:concept_maps/models/courses/branch.dart';

const kCourse = 'course';
const kCourses = 'courses';
const kBranches = 'branches';
const kCaption = 'caption';

class Course {
  final String name;
  final String caption;
  final List<String> nameBranches;
  final List<Branch> branches;

  Course({
    @required this.name,
    @required this.caption,
    @required this.nameBranches,
    this.branches,
  });

  Course copyWith({
    String name,
    String caption,
    List<String> nameBranches,
    List<Branch> branches,
  }) {
    return Course(
      name: name ?? this.name,
      caption: caption ?? this.caption,
      nameBranches: nameBranches ?? this.nameBranches,
      branches: branches ?? this.branches,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'caption': caption,
      'nameBranches': nameBranches,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      name: map['name'],
      caption: map['caption'],
      nameBranches: List<String>.from(map['nameBranches']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source));

  @override
  String toString() => 'Course(name: $name, caption: $caption, nameBranches: $nameBranches)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Course &&
        other.name == name &&
        other.caption == caption &&
        listEquals(other.nameBranches, nameBranches);
  }

  @override
  int get hashCode => name.hashCode ^ caption.hashCode ^ nameBranches.hashCode;
}
