import 'dart:async';

import 'package:app_maree/core/exceptions/failures.dart';
import 'package:app_maree/core/generics/resource.dart';
import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/feature/prediction/domain/repository/prediction_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'predictions_watcher_event.dart';
part 'predictions_watcher_state.dart';

class PredictionsWatcherBloc extends Bloc<PredictionsWatcherEvent, PredictionsWatcherState> {
  final PredictionRepository predictionRepository;

  PredictionsWatcherBloc({
    @required this.predictionRepository,
  }) : super(PredictionsWatcherInitial());

  @override
  Stream<PredictionsWatcherState> mapEventToState(
    PredictionsWatcherEvent event,
  ) async* {
    if (event is PredictionsReceived) {
      yield PredictionsWatcherLoading();
      print("PredictionsWatcherBloc");
      final Resource<List<PredictionDomainModel>> predictions = await predictionRepository.getPredictions();
      if (event.resource.status == Status.success) {
        yield PredictionsWatcherLoaded(predictions: predictions.data);
      } else if(event.resource.status == Status.failed){
        yield PredictionsWatcherFailure(failure: event.resource.failure);
      }
    }
  }
}

