import 'dart:async';

import 'package:app_maree/core/exceptions/failures.dart';
import 'package:app_maree/core/generics/resource.dart';
import 'package:app_maree/feature/levels/domain/model/level_domain_model.dart';
import 'package:app_maree/feature/levels/domain/repository/level_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'levels_watcher_event.dart';
part 'levels_watcher_state.dart';

class LevelsWatcherBloc extends Bloc<LevelsWatcherEvent, LevelsWatcherState>{
  final LevelRepository levelRepository;

  LevelsWatcherBloc({
    @required this.levelRepository,
  }) : assert(levelRepository != null), super(LevelsWatcherInitial());

  @override
  Stream<LevelsWatcherState> mapEventToState(
    LevelsWatcherEvent event,
  ) async* {
    print(event);
    if (event is LevelsReceived) {
      yield LevelsWatcherLoading();
      try {
        final Resource<List<LevelDomainModel>> levels = await levelRepository.getLevels();
        yield LevelsWatcherLoaded(levels: levels.data);
      } catch (_) {
        yield LevelsWatcherFailure();
      }
      //print("LevelsWatcherBloc");
      //final Resource<List<LevelDomainModel>> levels = await levelRepository.getLevels();
      //if (event == Status.success) {
      //  yield LevelsWatcherLoaded(levels: levels.data);
      //} else if(event.resource.status == Status.failed){
      //  yield LevelsWatcherFailure(failure: event.resource.failure);
      //}
    }
  }
}
