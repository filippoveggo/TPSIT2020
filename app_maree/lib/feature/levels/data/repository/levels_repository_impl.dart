import 'dart:async';

import 'package:app_maree/core/generics/resource.dart';
import 'package:app_maree/feature/levels/data/datasource/levels_remote_datasource.dart';
import 'package:app_maree/feature/levels/domain/model/level_domain_model.dart';
import 'package:app_maree/feature/levels/domain/repository/level_repository.dart';
import 'package:flutter/cupertino.dart';

class LevelsRepositoryImpl implements LevelRepository {
  final LevelsRemoteDatasource levelsRemoteDatasource;

  LevelsRepositoryImpl({
    @required this.levelsRemoteDatasource,
  });

  @override
  Future<Resource<List<LevelDomainModel>>> getLevels() async {
    try {
      final remoteLevels = await levelsRemoteDatasource.getLevels();
      final domainModels =
          remoteLevels.map((e) => LevelDomainModel.fromRemoteModel(e)).toList();
      Timer.periodic(
        Duration(seconds: 1),
        (Timer t) => levelsRemoteDatasource.getLevels(),
      );
      return Resource.success(data: domainModels);
    } catch (e) {
      return Resource.failed(error: e);
    }
  }
}
