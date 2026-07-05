import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/paginated_result.dart';
import '../entities/issue.dart';
import '../repositories/catalog_repository.dart';

class GetIssuesBySeriesUseCase {
  final CatalogRepository _repository;
  GetIssuesBySeriesUseCase(this._repository);
  Future<Either<Failure, PaginatedResult<Issue>>> call(
    String seriesId, {
    String? nextUrl,
  }) => _repository.getIssuesBySeries(seriesId, nextUrl: nextUrl);
}
