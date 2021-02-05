import 'package:app_maree/feature/levels/domain/repository/level_repository.dart';
import 'package:app_maree/feature/levels/levels_container.dart';
import 'package:app_maree/feature/prediction/domain/repository/prediction_repository.dart';
import 'package:app_maree/feature/prediction/prediction_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

class CoreContainer {
  static Future<void> init() async {
    await LevelsContainer.init();
    await PredictionsContainer.init();
  }

  static List<BlocProvider> getBlocProviders() {
    return [
      ...LevelsContainer.getBlocProviders(),
      ...PredictionsContainer.getBlocProviders(),
    ];
  }

  static List<RepositoryProvider> getRepositoryProviders() {
    return [
      RepositoryProvider<LevelRepository>(
        create: (BuildContext context) => sl(),
      ),
      RepositoryProvider<PredictionRepository>(
        create: (BuildContext context) => sl(),
      ),
    ];
  }
}
