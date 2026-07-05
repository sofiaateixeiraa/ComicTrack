import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/series.dart';
import '../../domain/entities/issue.dart';
import '../../domain/entities/paginated_result.dart';
import '../../domain/entities/publisher.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/metron_remote_datasource.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final MetronRemoteDataSource _dataSource;
  CatalogRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<Publisher>>> getPublishers() =>
      _dataSource.getPublishers();

  @override
  Future<Either<Failure, PaginatedResult<Series>>> getSeriesByPublisher(
    String publisherId, {
    String? nameFilter,
    String? nextUrl,
  }) => _dataSource.getSeriesByPublisher(
    publisherId,
    nameFilter: nameFilter,
    nextUrl: nextUrl,
  );

  @override
  Future<Either<Failure, PaginatedResult<Series>>> searchSeries(
    String query, {
    String? nextUrl,
  }) => _dataSource.searchSeries(query, nextUrl: nextUrl);

  @override
  Future<Either<Failure, Series>> getSeriesDetail(String seriesId) =>
      _dataSource.getSeriesDetail(seriesId);

  @override
  Future<Either<Failure, PaginatedResult<Issue>>> getIssuesBySeries(
    String seriesId, {
    String? nextUrl,
  }) => _dataSource.getIssuesBySeries(seriesId, nextUrl: nextUrl);

  @override
  Future<Either<Failure, Issue>> getIssueDetail(String issueId) =>
      _dataSource.getIssueDetail(issueId);
}
