import 'package:app_maree/core/generics/resource.dart';
import 'package:app_maree/feature/prediction/data/datasource/predictions_remote_datasource.dart';
import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';
import 'package:app_maree/feature/prediction/domain/repository/prediction_repository.dart';
import 'package:app_maree/utils/global_utils.dart';
import 'package:flutter/cupertino.dart';

class PredictionsRepositoryImpl extends PredictionRepository {
  final PredictionsRemoteDatasource predictionsRemoteDatasource;

  PredictionsRepositoryImpl({
    @required this.predictionsRemoteDatasource,
  });

  Future<Resource<Map<DateTime, List<PredictionDomainModel>>>>
      getPredictions() async {
    try {
      final remotePredictions =
          await predictionsRemoteDatasource.getPredictions();
      final domainModels = remotePredictions
          .map(
            (e) => PredictionDomainModel.fromRemoteModel(e),
          )
          .toList();

      final Map<DateTime, List<PredictionDomainModel>> map = Map.fromIterable(
        domainModels,
        key: (k) => k.extremeDate,
        value: (v) => domainModels.where((m) => GlobalUtils.areSameDay(m.extremeDate, v.extremeDate)).toList(),
      );

      return Resource.success(data: map);
    } catch (e) {
      return Resource.failed(error: e);
    }
  }
}
