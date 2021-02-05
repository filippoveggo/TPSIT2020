import 'package:app_maree/feature/levels/presentation/watcher/levels_watcher_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'data/datasource/levels_remote_datasource.dart';
import 'data/repository/levels_repository_impl.dart';
import 'domain/repository/level_repository.dart';

final GetIt sl = GetIt.instance;

class LevelsContainer {
  static Future<void> init() async {
    sl.registerLazySingleton(() => LevelsRemoteDatasource(dio: sl()));

    sl.registerLazySingleton<LevelRepository>(
      () => LevelsRepositoryImpl(
        levelsRemoteDatasource: sl(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<LevelsWatcherBloc>(
        create: (BuildContext contex) => LevelsWatcherBloc(
          levelRepository: sl(),
        ),
      ),
    ];
  }
}
