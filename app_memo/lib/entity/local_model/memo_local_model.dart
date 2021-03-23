import 'package:app_memo/entity/domain_model/memo_domain_model.dart';
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

@Entity(tableName: 'memos')
class MemoLocalModel {
  @primaryKey
  final String id;

  String title, description, creator;

  MemoLocalModel({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.creator,
  });

  MemoDomainModel toDomainModel({
    @required List<TagDomainModel> tags,
  }) {
    return MemoDomainModel(
      id: id,
      title: title,
      tags: tags,
      description: description,
      creator: creator,
    );
  }
}

@Entity(tableName: 'memos_tags', foreignKeys: [
  ForeignKey(
    childColumns: ['memo_id'],
    parentColumns: ['id'],
    entity: MemoLocalModel,
  ),
  ForeignKey(
    childColumns: ['tag_id'],
    parentColumns: ['id'],
    entity: TagLocalModel,
  )
])
class MemosTags {
  @PrimaryKey(autoGenerate: true)
  final int id;

  @ColumnInfo(name: 'memo_id')
  final String memoId;
  @ColumnInfo(name: 'tag_id')
  final String tagId;

  MemosTags({
    @required this.id,
    @required this.memoId,
    @required this.tagId,
  });
}

@Entity(tableName: 'tags')
class TagLocalModel {
  @primaryKey
  final String id;
  final String title;

  TagLocalModel({
    @required this.id,
    @required this.title,
  });

  TagDomainModel toDomainModel() {
    return TagDomainModel(
      id: id,
      title: title,
    );
  }
}
