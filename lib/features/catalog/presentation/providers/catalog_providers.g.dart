// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(metronCache)
final metronCacheProvider = MetronCacheProvider._();

final class MetronCacheProvider
    extends $FunctionalProvider<MetronCache, MetronCache, MetronCache>
    with $Provider<MetronCache> {
  MetronCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'metronCacheProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$metronCacheHash();

  @$internal
  @override
  $ProviderElement<MetronCache> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MetronCache create(Ref ref) {
    return metronCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MetronCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MetronCache>(value),
    );
  }
}

String _$metronCacheHash() => r'970198b3f989d563c9ffd23fc24155bb29bf97c2';

@ProviderFor(catalogRepository)
final catalogRepositoryProvider = CatalogRepositoryProvider._();

final class CatalogRepositoryProvider
    extends
        $FunctionalProvider<
          CatalogRepository,
          CatalogRepository,
          CatalogRepository
        >
    with $Provider<CatalogRepository> {
  CatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<CatalogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogRepository create(Ref ref) {
    return catalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogRepository>(value),
    );
  }
}

String _$catalogRepositoryHash() => r'32bcd82093dc267b88e7231a1485f30935f11a0b';

@ProviderFor(getPublishersUseCase)
final getPublishersUseCaseProvider = GetPublishersUseCaseProvider._();

final class GetPublishersUseCaseProvider
    extends
        $FunctionalProvider<
          GetPublishersUseCase,
          GetPublishersUseCase,
          GetPublishersUseCase
        >
    with $Provider<GetPublishersUseCase> {
  GetPublishersUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPublishersUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPublishersUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPublishersUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetPublishersUseCase create(Ref ref) {
    return getPublishersUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPublishersUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPublishersUseCase>(value),
    );
  }
}

String _$getPublishersUseCaseHash() =>
    r'a1a81ea6511fc6b1d469a78615a4621583944990';

@ProviderFor(getSeriesByPublisherUseCase)
final getSeriesByPublisherUseCaseProvider =
    GetSeriesByPublisherUseCaseProvider._();

final class GetSeriesByPublisherUseCaseProvider
    extends
        $FunctionalProvider<
          GetSeriesByPublisherUseCase,
          GetSeriesByPublisherUseCase,
          GetSeriesByPublisherUseCase
        >
    with $Provider<GetSeriesByPublisherUseCase> {
  GetSeriesByPublisherUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSeriesByPublisherUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSeriesByPublisherUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetSeriesByPublisherUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetSeriesByPublisherUseCase create(Ref ref) {
    return getSeriesByPublisherUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetSeriesByPublisherUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetSeriesByPublisherUseCase>(value),
    );
  }
}

String _$getSeriesByPublisherUseCaseHash() =>
    r'b92139cd717478296252c93de2f4c89117b11c26';

@ProviderFor(searchSeriesUseCase)
final searchSeriesUseCaseProvider = SearchSeriesUseCaseProvider._();

final class SearchSeriesUseCaseProvider
    extends
        $FunctionalProvider<
          SearchSeriesUseCase,
          SearchSeriesUseCase,
          SearchSeriesUseCase
        >
    with $Provider<SearchSeriesUseCase> {
  SearchSeriesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchSeriesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchSeriesUseCaseHash();

  @$internal
  @override
  $ProviderElement<SearchSeriesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SearchSeriesUseCase create(Ref ref) {
    return searchSeriesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchSeriesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchSeriesUseCase>(value),
    );
  }
}

String _$searchSeriesUseCaseHash() =>
    r'213ff98a501068450c1a26681c8a0b5570a50006';

@ProviderFor(getSeriesDetailUseCase)
final getSeriesDetailUseCaseProvider = GetSeriesDetailUseCaseProvider._();

final class GetSeriesDetailUseCaseProvider
    extends
        $FunctionalProvider<
          GetSeriesDetailUseCase,
          GetSeriesDetailUseCase,
          GetSeriesDetailUseCase
        >
    with $Provider<GetSeriesDetailUseCase> {
  GetSeriesDetailUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSeriesDetailUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSeriesDetailUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetSeriesDetailUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetSeriesDetailUseCase create(Ref ref) {
    return getSeriesDetailUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetSeriesDetailUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetSeriesDetailUseCase>(value),
    );
  }
}

String _$getSeriesDetailUseCaseHash() =>
    r'9554a0476b85151161e3e1c7274a0a143a3eb694';

@ProviderFor(getIssuesBySeriesUseCase)
final getIssuesBySeriesUseCaseProvider = GetIssuesBySeriesUseCaseProvider._();

final class GetIssuesBySeriesUseCaseProvider
    extends
        $FunctionalProvider<
          GetIssuesBySeriesUseCase,
          GetIssuesBySeriesUseCase,
          GetIssuesBySeriesUseCase
        >
    with $Provider<GetIssuesBySeriesUseCase> {
  GetIssuesBySeriesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getIssuesBySeriesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getIssuesBySeriesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetIssuesBySeriesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetIssuesBySeriesUseCase create(Ref ref) {
    return getIssuesBySeriesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetIssuesBySeriesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetIssuesBySeriesUseCase>(value),
    );
  }
}

String _$getIssuesBySeriesUseCaseHash() =>
    r'77d018ad1f5ddec58b4991032cdc1ba115900358';

@ProviderFor(getIssueDetailUseCase)
final getIssueDetailUseCaseProvider = GetIssueDetailUseCaseProvider._();

final class GetIssueDetailUseCaseProvider
    extends
        $FunctionalProvider<
          GetIssueDetailUseCase,
          GetIssueDetailUseCase,
          GetIssueDetailUseCase
        >
    with $Provider<GetIssueDetailUseCase> {
  GetIssueDetailUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getIssueDetailUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getIssueDetailUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetIssueDetailUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetIssueDetailUseCase create(Ref ref) {
    return getIssueDetailUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetIssueDetailUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetIssueDetailUseCase>(value),
    );
  }
}

String _$getIssueDetailUseCaseHash() =>
    r'6f8ddf3cc0d162cf321b6ca03d6376c02aae708b';

@ProviderFor(publishers)
final publishersProvider = PublishersProvider._();

final class PublishersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Publisher>>,
          List<Publisher>,
          FutureOr<List<Publisher>>
        >
    with $FutureModifier<List<Publisher>>, $FutureProvider<List<Publisher>> {
  PublishersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'publishersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$publishersHash();

  @$internal
  @override
  $FutureProviderElement<List<Publisher>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Publisher>> create(Ref ref) {
    return publishers(ref);
  }
}

String _$publishersHash() => r'd5a156e7944acd4ceedb651ada2493d8e38f26f1';

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'286abcff51dc844febe02639bb2e883ccab22cfd';

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// resultados da pesquisa global.

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

/// resultados da pesquisa global.

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaginatedResult<Series>>,
          PaginatedResult<Series>,
          FutureOr<PaginatedResult<Series>>
        >
    with
        $FutureModifier<PaginatedResult<Series>>,
        $FutureProvider<PaginatedResult<Series>> {
  /// resultados da pesquisa global.
  SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $FutureProviderElement<PaginatedResult<Series>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaginatedResult<Series>> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'c8e29d9e0e34df967656dc0b70cd86f32e9f3890';

/// issues de uma série.

@ProviderFor(seriesIssues)
final seriesIssuesProvider = SeriesIssuesFamily._();

/// issues de uma série.

final class SeriesIssuesProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaginatedResult<Issue>>,
          PaginatedResult<Issue>,
          FutureOr<PaginatedResult<Issue>>
        >
    with
        $FutureModifier<PaginatedResult<Issue>>,
        $FutureProvider<PaginatedResult<Issue>> {
  /// issues de uma série.
  SeriesIssuesProvider._({
    required SeriesIssuesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'seriesIssuesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seriesIssuesHash();

  @override
  String toString() {
    return r'seriesIssuesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PaginatedResult<Issue>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaginatedResult<Issue>> create(Ref ref) {
    final argument = this.argument as String;
    return seriesIssues(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeriesIssuesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seriesIssuesHash() => r'e3c8e2c820539eceb23ed8d84dd81fd49b1b8da8';

/// issues de uma série.

final class SeriesIssuesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PaginatedResult<Issue>>, String> {
  SeriesIssuesFamily._()
    : super(
        retry: null,
        name: r'seriesIssuesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// issues de uma série.

  SeriesIssuesProvider call(String seriesId) =>
      SeriesIssuesProvider._(argument: seriesId, from: this);

  @override
  String toString() => r'seriesIssuesProvider';
}
