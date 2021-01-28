part of 'levels_watcher_bloc.dart';

abstract class LevelsWatcherEvent{
  const LevelsWatcherEvent();
}

class LevelsReceived extends LevelsWatcherEvent{
  LevelsReceived();
}