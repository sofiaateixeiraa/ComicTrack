import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/paginated_result.dart';
import '../entities/series.dart';
import '../repositories/catalog_repository.dart';

class SearchSeriesUseCase {
  final CatalogRepository _repository;
  SearchSeriesUseCase(this._repository);
  Future<Either<Failure, PaginatedResult<Series>>> call(
    String query, {
    String? nextUrl,
  }) => _repository.searchSeries(query, nextUrl: nextUrl);
}
