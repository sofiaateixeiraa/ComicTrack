import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/paginated_result.dart';
import '../entities/series.dart';
import '../repositories/catalog_repository.dart';

class GetSeriesByPublisherUseCase {
  final CatalogRepository _repository;
  GetSeriesByPublisherUseCase(this._repository);
  Future<Either<Failure, PaginatedResult<Series>>> call({
    required String publisherId,
    String? publisherName,
    String? nameFilter,
    String sort = 'name',
    String? nextUrl,
  }) => _repository.getSeriesByPublisher(
    publisherId,
    publisherName: publisherName,
    nameFilter: nameFilter,
    sort: sort,
    nextUrl: nextUrl,
  );
}
