part of 'levels_watcher_bloc.dart';

abstract class LevelsWatcherEvent{
  const LevelsWatcherEvent();
}

class LevelsReceived extends LevelsWatcherEvent{
  final Resource<List<LevelDomainModel>> resource;

  LevelsReceived({
    @required this.resource,
  }) : assert(resource != null);
}