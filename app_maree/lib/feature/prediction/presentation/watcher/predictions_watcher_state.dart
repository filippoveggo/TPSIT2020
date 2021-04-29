part of 'predictions_watcher_bloc.dart';

@immutable
abstract class PredictionsWatcherState {
  const PredictionsWatcherState();
}

class PredictionsWatcherInitial extends PredictionsWatcherState {}

class PredictionsWatcherLoading extends PredictionsWatcherState {}

class PredictionsWatcherLoaded extends PredictionsWatcherState {
  final List<PredictionDomainModel> predictions;

  PredictionsWatcherLoaded({
    @required this.predictions,
  }) : assert(predictions != null);
}

class PredictionsWatcherFailure extends PredictionsWatcherState {}
