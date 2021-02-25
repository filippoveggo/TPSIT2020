import 'dart:async';

import 'package:app_maree/core/generics/resource.dart';
import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/feature/prediction/domain/repository/prediction_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'predictions_watcher_event.dart';
part 'predictions_watcher_state.dart';

class PredictionsWatcherBloc
    extends Bloc<PredictionsWatcherEvent, PredictionsWatcherState> {
  final PredictionRepository predictionRepository;

  PredictionsWatcherBloc({
    @required this.predictionRepository,
  })  : assert(predictionRepository != null),
        super(PredictionsWatcherInitial());

  @override
  Stream<PredictionsWatcherState> mapEventToState(
    PredictionsWatcherEvent event,
  ) async* {
    if (event is PredictionsReceived) {
      yield PredictionsWatcherLoading();
      try {
        final Resource<List<PredictionDomainModel>> predictions =
            await predictionRepository.getPredictions();
        yield PredictionsWatcherLoaded(predictions: predictions.data);
      } catch (_) {
        yield PredictionsWatcherFailure();
      }
    }
  }
}
