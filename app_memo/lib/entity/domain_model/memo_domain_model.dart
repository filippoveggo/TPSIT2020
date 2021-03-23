import 'dart:convert';

import 'package:app_memo/entity/local_model/memo_local_model.dart';
import 'package:flutter/material.dart';

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
  List<TagDomainModel> tags;
  String creator;

  MemoDomainModel({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.tags,
    @required this.creator,
  });

  MemoLocalModel toLocalModel() {
    return MemoLocalModel(
      id: id,
      title: title,
      description: description,
      creator: creator,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tags': tags?.map((x) => x?.toMap())?.toList(),
      'creator': creator,
    };
  }

  factory MemoDomainModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MemoDomainModel(
      id: map['id'],
      title: map['title'],
      tags: List<TagDomainModel>.from(
          map['tags']?.map((x) => TagDomainModel.fromMap(x))),
      description: map['description'],
      creator: map['creator'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MemoDomainModel.fromJson(String source) =>
      MemoDomainModel.fromMap(json.decode(source));

  MemoDomainModel copyWith({
    String id,
    String title,
    String description,
    List<TagDomainModel> tags,
    String creator,
  }) {
    return MemoDomainModel(
      id: id ?? this.id,
      title: title ?? this.title,
      tags: tags ?? this.tags,
      description: description ?? this.description,
      creator: creator ?? this.creator,
    );
  }
}

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
