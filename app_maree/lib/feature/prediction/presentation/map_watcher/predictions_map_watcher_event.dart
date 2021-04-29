part of 'predictions_map_watcher_bloc.dart';

abstract class PredictionsMapWatcherEvent extends Equatable {
  const PredictionsMapWatcherEvent();

  @override
  List<Object> get props => [];
}

class GetPredictionsMap extends PredictionsMapWatcherEvent {}
