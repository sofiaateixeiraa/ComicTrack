// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publisher_series_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(publisherSeries)
final publisherSeriesProvider = PublisherSeriesFamily._();

final class PublisherSeriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaginatedResult<Series>>,
          PaginatedResult<Series>,
          FutureOr<PaginatedResult<Series>>
        >
    with
        $FutureModifier<PaginatedResult<Series>>,
        $FutureProvider<PaginatedResult<Series>> {
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
  $FutureProviderElement<PaginatedResult<Series>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaginatedResult<Series>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              String publisherId,
              String publisherName,
              String? nameFilter,
              String sort,
            });
    return publisherSeries(
      ref,
      publisherId: argument.publisherId,
      publisherName: argument.publisherName,
      nameFilter: argument.nameFilter,
      sort: argument.sort,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PublisherSeriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$publisherSeriesHash() => r'9e5116bf45a33046dcc9328ea57c977d0465ce28';

final class PublisherSeriesFamily extends $Family
    with
        $FunctionalFamilyOverride<
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
