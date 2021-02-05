part of 'predictions_watcher_bloc.dart';

abstract class PredictionsWatcherEvent {
  const PredictionsWatcherEvent();
}

class PredictionsReceived extends PredictionsWatcherEvent {
  PredictionsReceived();
}
