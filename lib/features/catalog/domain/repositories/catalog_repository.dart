import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/series.dart';
import '../entities/issue.dart';
import '../entities/publisher.dart';
import '../entities/paginated_result.dart';

abstract interface class CatalogRepository {
  /// devolve lista de editoras disponíveis na API Metron.
  Future<Either<Failure, List<Publisher>>> getPublishers();

  /// lista séries de uma editora, com suporte a pesquisa e ordenação.
  /// [sort]: 'name' (A-Z) | '-year_began' (mais recente).
  /// [nextUrl]: URL completa de paginação devolvida pela API; se null, primeira página.
  Future<Either<Failure, PaginatedResult<Series>>> getSeriesByPublisher(
    String publisherId, {
    String? nameFilter,
    String sort = 'name',
    String? nextUrl,
  });

  /// pesquisa global de séries por título em todas as editoras.
  Future<Either<Failure, PaginatedResult<Series>>> searchSeries(
    String query, {
    String? nextUrl,
  });

  /// detalhes completos de uma série pelo id.
  Future<Either<Failure, Series>> getSeriesDetail(String seriesId);

  /// lista de issues de uma série.
  Future<Either<Failure, PaginatedResult<Issue>>> getIssuesBySeries(
    String seriesId, {
    String? nextUrl,
  });

  /// detalhes completos de um issue pelo id.
  Future<Either<Failure, Issue>> getIssueDetail(String issueId);
}