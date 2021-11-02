part of 'levels_watcher_bloc.dart';

@immutable
abstract class LevelsWatcherState {
  const LevelsWatcherState();
}

class LevelsWatcherInitial extends LevelsWatcherState {}

class LevelsWatcherLoading extends LevelsWatcherState {}

class LevelsWatcherLoaded extends LevelsWatcherState {
  final List<LevelDomainModel> levels;
  LevelsWatcherLoaded({
    @required this.levels,
  }) : assert(levels != null);
}

class LevelsWatcherFailure extends LevelsWatcherState {
  //final Failure failure;
  //LevelsWatcherFailure({@required this.failure});
}
