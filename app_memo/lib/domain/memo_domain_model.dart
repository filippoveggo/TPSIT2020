import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:app_memo/data/model/memo_local_model.dart';

class MemosPageData {
  List<MemoDomainModel> memos;
  List<TagDomainModel> tags;

  MemosPageData({
    @required this.memos,
    @required this.tags,
  });
}

class MemoDomainModel {
  final String id;
  String title;
  String description;
  String creator;
  List<TagDomainModel> tags;

  MemoDomainModel({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.creator,
    @required this.tags,
  });

  MemoLocalModel toLocalModel() {
    return MemoLocalModel(
      id: id,
      title: title,
      creator: creator,
      description: description,
    );
  }

  MemoDomainModel copyWith({
    String id,
    String title,
    String description,
    String creator,
    List<TagDomainModel> tags,
  }) {
    return MemoDomainModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      creator: creator ?? this.creator,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'creator': creator,
      'tags': tags?.map((x) => x.toMap())?.toList(),
    };
  }

  factory MemoDomainModel.fromMap(Map<String, dynamic> map) {
    return MemoDomainModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      creator: map['creator'],
      tags: List<TagDomainModel>.from(
          map['tags']?.map((x) => TagDomainModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory MemoDomainModel.fromJson(String source) =>
      MemoDomainModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MemoDomainModel(id: $id, title: $title, description: $description, creator: $creator, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MemoDomainModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.creator == creator &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        creator.hashCode ^
        tags.hashCode;
  }
}

enum MemoState { all, shared, archived, pinned }

class TagDomainModel {
  final String id;
  String title;

  TagDomainModel({
    @required this.id,
    @required this.title,
  });

  TagLocalModel toLocalModel() {
    return TagLocalModel(
      id: id,
      title: title,
    );
  }

  @override
  String toString() => 'TagDomainModel(id: $id, title: $title)';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory TagDomainModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return TagDomainModel(
      id: map['id'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TagDomainModel.fromJson(String source) =>
      TagDomainModel.fromMap(json.decode(source));
}
