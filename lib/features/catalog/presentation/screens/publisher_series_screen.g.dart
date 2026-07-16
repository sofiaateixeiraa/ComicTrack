// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publisher_series_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PublisherSeries)
final publisherSeriesProvider = PublisherSeriesFamily._();

final class PublisherSeriesProvider
    extends $AsyncNotifierProvider<PublisherSeries, PaginatedResult<Series>> {
  PublisherSeriesProvider._({
    required PublisherSeriesFamily super.from,
    required ({
      String publisherId,
      String publisherName,
      String? nameFilter,
      String sort,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'publisherSeriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$publisherSeriesHash();

  @override
  String toString() {
    return r'publisherSeriesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PublisherSeries create() => PublisherSeries();

  @override
  bool operator ==(Object other) {
    return other is PublisherSeriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$publisherSeriesHash() => r'72796a21e874071c3eafee351114229d60b29c76';

final class PublisherSeriesFamily extends $Family
    with
        $ClassFamilyOverride<
          PublisherSeries,
          AsyncValue<PaginatedResult<Series>>,
          PaginatedResult<Series>,
          FutureOr<PaginatedResult<Series>>,
          ({
            String publisherId,
            String publisherName,
            String? nameFilter,
            String sort,
          })
        > {
  PublisherSeriesFamily._()
    : super(
        retry: null,
        name: r'publisherSeriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PublisherSeriesProvider call({
    required String publisherId,
    required String publisherName,
    String? nameFilter,
    String sort = 'name',
  }) => PublisherSeriesProvider._(
    argument: (
      publisherId: publisherId,
      publisherName: publisherName,
      nameFilter: nameFilter,
      sort: sort,
    ),
    from: this,
  );

  @override
  String toString() => r'publisherSeriesProvider';
}

abstract class _$PublisherSeries
    extends $AsyncNotifier<PaginatedResult<Series>> {
  late final _$args =
      ref.$arg
          as ({
            String publisherId,
            String publisherName,
            String? nameFilter,
            String sort,
          });
  String get publisherId => _$args.publisherId;
  String get publisherName => _$args.publisherName;
  String? get nameFilter => _$args.nameFilter;
  String get sort => _$args.sort;

  FutureOr<PaginatedResult<Series>> build({
    required String publisherId,
    required String publisherName,
    String? nameFilter,
    String sort = 'name',
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PaginatedResult<Series>>,
              PaginatedResult<Series>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PaginatedResult<Series>>,
                PaginatedResult<Series>
              >,
              AsyncValue<PaginatedResult<Series>>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        publisherId: _$args.publisherId,
        publisherName: _$args.publisherName,
        nameFilter: _$args.nameFilter,
        sort: _$args.sort,
      ),
    );
  }
}
