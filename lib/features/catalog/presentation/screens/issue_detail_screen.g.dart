// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_detail_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(issueDetail)
final issueDetailProvider = IssueDetailFamily._();

final class IssueDetailProvider
    extends $FunctionalProvider<AsyncValue<Issue>, Issue, FutureOr<Issue>>
    with $FutureModifier<Issue>, $FutureProvider<Issue> {
  IssueDetailProvider._({
    required IssueDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'issueDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$issueDetailHash();

  @override
  String toString() {
    return r'issueDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Issue> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Issue> create(Ref ref) {
    final argument = this.argument as String;
    return issueDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IssueDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$issueDetailHash() => r'25338ac7b81890901c88b14854314983084e4b63';

final class IssueDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Issue>, String> {
  IssueDetailFamily._()
    : super(
        retry: null,
        name: r'issueDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IssueDetailProvider call(String issueId) =>
      IssueDetailProvider._(argument: issueId, from: this);

  @override
  String toString() => r'issueDetailProvider';
}
