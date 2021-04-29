import 'dart:async';

import 'package:app_maree/feature/prediction/data/repository/predictions_repository_impl.dart';
import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/feature/prediction/domain/repository/prediction_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'predictions_map_watcher_event.dart';
part 'predictions_map_watcher_state.dart';

class PredictionsMapWatcherBloc
    extends Bloc<PredictionsMapWatcherEvent, PredictionsMapWatcherState> {
  final PredictionRepository predictionRepository;

  PredictionsMapWatcherBloc({
    @required this.predictionRepository,
  }) : super(PredictionsMapWatcherInitial());

  @override
  Stream<PredictionsMapWatcherState> mapEventToState(
    PredictionsMapWatcherEvent event,
  ) async* {
    if (event is GetPredictionsMap) {
      yield PredictionsMapWatcherLoading();

      try {
        final predictionsMap = await predictionRepository.getPredictionsMap();

        yield PredictionsMapWatcherLoaded(predictionsMap.data);
      } catch (e) {
        print(e);
        yield PredictionsMapWatcherFailure();
      }
    }
  }
}
