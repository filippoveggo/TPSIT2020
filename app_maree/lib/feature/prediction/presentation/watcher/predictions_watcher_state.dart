part of 'predictions_watcher_bloc.dart';

@immutable
abstract class PredictionsWatcherState {}

class PredictionsWatcherInitial extends PredictionsWatcherState {}

class PredictionsWatcherLoading extends PredictionsWatcherState {}

class PredictionsWatcherLoaded extends PredictionsWatcherState {
  final List<PredictionDomainModel> predictions;

  PredictionsWatcherLoaded({
    @required this.predictions,
  });
}

class PredictionsWatcherFailure extends PredictionsWatcherState {
  final Failure failure;

  PredictionsWatcherFailure({@required this.failure});
}
