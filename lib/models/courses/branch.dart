import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Branch {
  final String view;
  final String parentView;
  final String caption;
  final String intro;
  final String text;
  final List<Branch> children;

  Branch({
    @required this.view,
    @required this.parentView,
    @required this.caption,
    @required this.intro,
    this.text = '',
    this.children = const [],
  });

  bool get endBranch => children.isEmpty;

  Branch copyWith({
    String view,
    String parentView,
    String caption,
    String intro,
    String text,
    List<Branch> children,
  }) {
    return Branch(
      view: view ?? this.view,
      parentView: parentView ?? this.parentView,
      caption: caption ?? this.caption,
      intro: intro ?? this.intro,
      text: text ?? this.text,
      children: children ?? this.children,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'view': view,
      'parentView': parentView,
      'caption': caption,
      'intro': intro,
      'text': text,
      'children': children?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      view: map['view'],
      parentView: map['parentView'],
      caption: map['caption'],
      intro: map['intro'],
      text: map['text'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Branch.fromJson(String source) => Branch.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Branch(view: $view, parentView: $parentView, caption: $caption, intro: $intro, text: $text, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Branch &&
        other.view == view &&
        other.parentView == parentView &&
        other.caption == caption &&
        other.intro == intro &&
        other.text == text &&
        listEquals(other.children, children);
  }

  @override
  int get hashCode {
    return view.hashCode ^ parentView.hashCode ^ caption.hashCode ^ intro.hashCode ^ text.hashCode ^ children.hashCode;
  }
}
