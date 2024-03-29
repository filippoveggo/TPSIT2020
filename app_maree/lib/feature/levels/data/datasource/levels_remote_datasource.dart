import 'package:app_maree/feature/levels/data/models/level_remote_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class LevelsRemoteDatasource {
  final Dio dio;

  LevelsRemoteDatasource({
    @required this.dio,
  });

  Future<List<LevelRemoteModel>> getLevels() async {
    final response = await dio.get('https://dati.venezia.it/sites/default/files/dataset/opendata/livello.json', options: Options(responseType: ResponseType.json));
    List<LevelRemoteModel> levelsList = List<LevelRemoteModel>.from(
        response.data.map((i) => LevelRemoteModel.fromJson(i)));
    return levelsList;
  }
}
