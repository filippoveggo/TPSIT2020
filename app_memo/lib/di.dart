import 'package:app_memo/data/repository/memos_repository.dart';
import 'package:get_it/get_it.dart';

import 'data/database/memos_database.dart';

final sl = GetIt.instance;

class MemosDI {
  static Future<void> init() async {
    final database =
        await $FloorMemosDatabase.databaseBuilder('memos.db').build();
    sl.registerLazySingleton(() => database);

    sl.registerLazySingleton(() => database.memosDao);

    sl.registerLazySingleton(() => MemosRepository(memosDao: sl()));
  }
}
