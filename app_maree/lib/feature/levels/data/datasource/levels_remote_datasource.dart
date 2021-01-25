import 'package:app_maree/feature/levels/data/models/level_remote_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class LevelsRemoteDatasource {
  final Dio dio;

  LevelsRemoteDatasource({
    @required this.dio,
  });

  Future<List<LevelRemoteModel>> getLevels() async {
    final response = await dio.get('https://dati.venezia.it/sites/default/files/dataset/opendata/livello.json');

    List<LevelRemoteModel> levelsList = List<LevelRemoteModel>.from(
        response.data.map((i) => LevelRemoteModel.fromJson(i)));
    print(levelsList.toString());
    return levelsList;
  }
}
