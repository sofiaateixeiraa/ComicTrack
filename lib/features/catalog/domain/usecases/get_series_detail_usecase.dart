import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/series.dart';
import '../repositories/catalog_repository.dart';

class GetSeriesDetailUseCase {
  final CatalogRepository _repository;
  GetSeriesDetailUseCase(this._repository);
  Future<Either<Failure, Series>> call(String seriesId) =>
      _repository.getSeriesDetail(seriesId);
}
