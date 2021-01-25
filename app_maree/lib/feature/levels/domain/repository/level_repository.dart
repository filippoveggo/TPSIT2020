import 'package:app_maree/core/generics/resource.dart';
import 'package:app_maree/feature/levels/domain/model/level_domain_model.dart';

abstract class LevelRepository {

  Future<Resource<List<LevelDomainModel>>> getLevels();

}