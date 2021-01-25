import 'package:app_maree/core/generics/resource.dart';
import 'package:app_maree/feature/prediction/data/datasource/predictions_remote_datasource.dart';
import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/feature/prediction/domain/repository/prediction_repository.dart';
import 'package:flutter/cupertino.dart';

class PredictionsRepositoryImpl extends PredictionRepository {
  final PredictionsRemoteDatasource predictionsRemoteDatasource;

  PredictionsRepositoryImpl({
    @required this.predictionsRemoteDatasource,
  });

  Future<Resource<List<PredictionDomainModel>>> getPredictions() async{
    try {
      final remotePredictions = await predictionsRemoteDatasource.getPredictions();
      final domainModels = remotePredictions.map((e) => PredictionDomainModel.fromRemoteModel(e));
      return Resource.success(data: domainModels);
    } catch (e) {
      print(e);
      return Resource.failed(error: e);
    }
  }
}
