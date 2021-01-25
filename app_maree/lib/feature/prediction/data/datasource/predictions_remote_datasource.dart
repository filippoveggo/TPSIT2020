
import 'package:app_maree/feature/prediction/data/models/prediction_remote_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class PredictionsRemoteDatasource {
  final Dio dio;

  PredictionsRemoteDatasource({
    @required this.dio,
  });

  Future<List<PredictionRemoteModel>> getPredictions() async {
    final response = await dio.get('https://dati.venezia.it/sites/default/files/dataset/opendata/previsione.json');

    List<PredictionRemoteModel> predictionsList = List<PredictionRemoteModel>.from(
        response.data.map((i) => PredictionRemoteModel.fromJson(i)));

    return predictionsList;
  }
}
