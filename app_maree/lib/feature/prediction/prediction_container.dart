import 'package:app_maree/feature/prediction/presentation/watcher/predictions_watcher_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'data/datasource/predictions_remote_datasource.dart';
import 'data/repository/predictions_repository_impl.dart';
import 'domain/repository/prediction_repository.dart';

final sl = GetIt.instance;

class PredictionsContainer {
  static Future<void> init() async {
    sl.registerLazySingleton(() => PredictionsRemoteDatasource(dio: sl()));

    sl.registerLazySingleton<PredictionRepository>(
      () => PredictionsRepositoryImpl(
        predictionsRemoteDatasource: sl(),
      ),
    );
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      BlocProvider<PredictionsWatcherBloc>(
        create: (BuildContext contex) => PredictionsWatcherBloc(
          predictionRepository: sl(),
        ),
      ),
    ];
  }
}
