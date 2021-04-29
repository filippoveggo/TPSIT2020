part of 'predictions_map_watcher_bloc.dart';

abstract class PredictionsMapWatcherState extends Equatable {
  const PredictionsMapWatcherState();

  @override
  List<Object> get props => [];
}

class PredictionsMapWatcherInitial extends PredictionsMapWatcherState {}

class PredictionsMapWatcherLoading extends PredictionsMapWatcherState {}

class PredictionsMapWatcherLoaded extends PredictionsMapWatcherState {
  final Map<DateTime, List<PredictionDomainModel>> map;

  PredictionsMapWatcherLoaded(this.map);
}

class PredictionsMapWatcherFailure extends PredictionsMapWatcherState {}
