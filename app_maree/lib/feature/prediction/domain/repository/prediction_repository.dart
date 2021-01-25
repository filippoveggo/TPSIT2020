import 'package:app_maree/core/generics/resource.dart';
import 'package:app_maree/feature/prediction/domain/model/prediction_domain_model.dart';

abstract class PredictionRepository {

  Future<Resource<List<PredictionDomainModel>>> getPredictions();

}