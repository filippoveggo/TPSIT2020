import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../model/memo_local_model.dart';
import 'dao/memo_dao.dart';

part 'memos_database.g.dart';

@Database(version: 1, entities: [
  MemoLocalModel,
  TagLocalModel,
  MemosTags,
])
abstract class MemosDatabase extends FloorDatabase {
  MemosDao get memosDao;

  Future<void> clearAllTables() async {
    await database.execute('DELETE FROM memos_tags');
    await database.execute('DELETE FROM tags');
    await database.execute('DELETE FROM memos');
  }
}
