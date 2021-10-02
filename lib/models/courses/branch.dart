import 'dart:convert';
import 'package:flutter/material.dart';

class Branch {
  final String view;
  final String parentView;
  final String caption;
  final String intro;
  Branch({
    @required this.view,
    @required this.parentView,
    @required this.caption,
    @required this.intro,
  });

  Branch copyWith({
    String view,
    String parentView,
    String caption,
    String intro,
  }) {
    return Branch(
      view: view ?? this.view,
      parentView: parentView ?? this.parentView,
      caption: caption ?? this.caption,
      intro: intro ?? this.intro,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'view': view,
      'parentView': parentView,
      'caption': caption,
      'intro': intro,
    };
  }

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      view: map['view'],
      parentView: map['parentView'],
      caption: map['caption'],
      intro: map['intro'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Branch.fromJson(String source) => Branch.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Branch(view: $view, parentView: $parentView, caption: $caption, intro: $intro)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Branch &&
        other.view == view &&
        other.parentView == parentView &&
        other.caption == caption &&
        other.intro == intro;
  }

  @override
  int get hashCode {
    return view.hashCode ^ parentView.hashCode ^ caption.hashCode ^ intro.hashCode;
  }
}
