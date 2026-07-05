import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/metron_client.dart';
import '../../data/datasources/metron_remote_datasource.dart';
import '../../data/repositories/catalog_repository_impl.dart';
import '../../domain/entities/series.dart';
import '../../domain/entities/issue.dart';
import '../../domain/entities/paginated_result.dart';
import '../../domain/entities/publisher.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../../domain/usecases/get_publishers_usecase.dart';
import '../../domain/usecases/get_series_by_publisher_usecase.dart';
import '../../domain/usecases/search_series_usecase.dart';
import '../../domain/usecases/get_series_detail_usecase.dart';
import '../../domain/usecases/get_issues_by_series_usecase.dart';
import '../../domain/usecases/get_issue_detail_usecase.dart';
part 'catalog_providers.g.dart';

@riverpod
MetronCache metronCache(Ref ref) => MetronCache();

@riverpod
CatalogRepository catalogRepository(Ref ref) {
  final dio = createMetronClient();
  final cache = ref.watch(metronCacheProvider);
  final ds = MetronRemoteDataSourceImpl(dio: dio, cache: cache);
  return CatalogRepositoryImpl(ds);
}

@riverpod
GetPublishersUseCase getPublishersUseCase(Ref ref) =>
    GetPublishersUseCase(ref.watch(catalogRepositoryProvider));

@riverpod
GetSeriesByPublisherUseCase getSeriesByPublisherUseCase(Ref ref) =>
    GetSeriesByPublisherUseCase(ref.watch(catalogRepositoryProvider));

@riverpod
SearchSeriesUseCase searchSeriesUseCase(Ref ref) =>
    SearchSeriesUseCase(ref.watch(catalogRepositoryProvider));

@riverpod
GetSeriesDetailUseCase getSeriesDetailUseCase(Ref ref) =>
    GetSeriesDetailUseCase(ref.watch(catalogRepositoryProvider));

@riverpod
GetIssuesBySeriesUseCase getIssuesBySeriesUseCase(Ref ref) =>
    GetIssuesBySeriesUseCase(ref.watch(catalogRepositoryProvider));

@riverpod
GetIssueDetailUseCase getIssueDetailUseCase(Ref ref) =>
    GetIssueDetailUseCase(ref.watch(catalogRepositoryProvider));

@riverpod
Future<List<Publisher>> publishers(Ref ref) async {
  final result = await ref.watch(getPublishersUseCaseProvider).call();
  return result.fold((failure) => throw failure, (publishers) => publishers);
}

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';
  void update(String query) => state = query;
}

/// resultados da pesquisa global.
@riverpod
Future<PaginatedResult<Series>> searchResults(Ref ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return const PaginatedResult(items: [], total: 0);
  final result = await ref.watch(searchSeriesUseCaseProvider).call(query);
  return result.fold((f) => throw f, (r) => r);
}

/// issues de uma série.
@riverpod
Future<PaginatedResult<Issue>> seriesIssues(Ref ref, String seriesId) async {
  final result = await ref
      .watch(getIssuesBySeriesUseCaseProvider)
      .call(seriesId);
  return result.fold((f) => throw f, (r) => r);
}
