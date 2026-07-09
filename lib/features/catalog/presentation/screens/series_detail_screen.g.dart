// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_detail_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(seriesDetail)
final seriesDetailProvider = SeriesDetailFamily._();

final class SeriesDetailProvider
    extends $FunctionalProvider<AsyncValue<Series>, Series, FutureOr<Series>>
    with $FutureModifier<Series>, $FutureProvider<Series> {
  SeriesDetailProvider._({
    required SeriesDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'seriesDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seriesDetailHash();

  @override
  String toString() {
    return r'seriesDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Series> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Series> create(Ref ref) {
    final argument = this.argument as String;
    return seriesDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SeriesDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seriesDetailHash() => r'ed500fe534f75f2de0c3f6622064efd3e2e021dd';

final class SeriesDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Series>, String> {
  SeriesDetailFamily._()
    : super(
        retry: null,
        name: r'seriesDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeriesDetailProvider call(String seriesId) =>
      SeriesDetailProvider._(argument: seriesId, from: this);

  @override
  String toString() => r'seriesDetailProvider';
}
