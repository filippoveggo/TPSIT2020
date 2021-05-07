import 'package:app_maree/core/generics/resource.dart';
import 'package:app_maree/feature/prediction/data/datasource/predictions_remote_datasource.dart';
import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/feature/prediction/domain/repository/prediction_repository.dart';
import 'package:app_maree/utils/global_utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

class PredictionsRepositoryImpl extends PredictionRepository {
  final PredictionsRemoteDatasource predictionsRemoteDatasource;

  PredictionsRepositoryImpl({
    @required this.predictionsRemoteDatasource,
  });

  Future<Resource<List<PredictionDomainModel>>>
      getPredictions() async {
    try {
      final remotePredictions =
          await predictionsRemoteDatasource.getPredictions();
      final domainModels = remotePredictions
          .map(
            (e) => PredictionDomainModel.fromRemoteModel(e),
          )
          .toList();

      return Resource.success(data: domainModels);
    } catch (e) {
      return Resource.failed(error: e);
    }
  }

  @override
  Future<Resource<Map<DateTime, List<PredictionDomainModel>>>>
      getPredictionsMap() async {
    try {
      final remotePredictions =
          await predictionsRemoteDatasource.getPredictions();
      final domainModels = remotePredictions
          .map(
            (e) => PredictionDomainModel.fromRemoteModel(e),
          )
          .toList();

      final predictionsMap = groupBy<PredictionDomainModel, DateTime>(
        domainModels,
        (e) => DateTime(
          e.extremeDate.year,
          e.extremeDate.month,
          e.extremeDate.day
        )
      );

      return Resource.success(data: predictionsMap);
    } catch (e) {
      return Resource.failed(error: e);
    }
  }
}
