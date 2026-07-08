// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(collectionRepository)
final collectionRepositoryProvider = CollectionRepositoryProvider._();

final class CollectionRepositoryProvider
    extends
        $FunctionalProvider<
          CollectionRepository,
          CollectionRepository,
          CollectionRepository
        >
    with $Provider<CollectionRepository> {
  CollectionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionRepositoryHash();

  @$internal
  @override
  $ProviderElement<CollectionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CollectionRepository create(Ref ref) {
    return collectionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CollectionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CollectionRepository>(value),
    );
  }
}

String _$collectionRepositoryHash() =>
    r'473d297b67d2007399372d4b890b2e0e2e72c65d';

@ProviderFor(updateOwnershipStatus)
final updateOwnershipStatusProvider = UpdateOwnershipStatusProvider._();

final class UpdateOwnershipStatusProvider
    extends
        $FunctionalProvider<
          UpdateOwnershipStatusUseCase,
          UpdateOwnershipStatusUseCase,
          UpdateOwnershipStatusUseCase
        >
    with $Provider<UpdateOwnershipStatusUseCase> {
  UpdateOwnershipStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateOwnershipStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateOwnershipStatusHash();

  @$internal
  @override
  $ProviderElement<UpdateOwnershipStatusUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateOwnershipStatusUseCase create(Ref ref) {
    return updateOwnershipStatus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateOwnershipStatusUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateOwnershipStatusUseCase>(value),
    );
  }
}

String _$updateOwnershipStatusHash() =>
    r'012c29da7dbd15e64bfa0eefc8de3f7338d81898';

@ProviderFor(updateReadingStatus)
final updateReadingStatusProvider = UpdateReadingStatusProvider._();

final class UpdateReadingStatusProvider
    extends
        $FunctionalProvider<
          UpdateReadingStatusUseCase,
          UpdateReadingStatusUseCase,
          UpdateReadingStatusUseCase
        >
    with $Provider<UpdateReadingStatusUseCase> {
  UpdateReadingStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateReadingStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateReadingStatusHash();

  @$internal
  @override
  $ProviderElement<UpdateReadingStatusUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateReadingStatusUseCase create(Ref ref) {
    return updateReadingStatus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateReadingStatusUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateReadingStatusUseCase>(value),
    );
  }
}

String _$updateReadingStatusHash() =>
    r'ef4dcab9249097f1911e200a7aa4ce10c6f1c8ed';

@ProviderFor(toggleFavorite)
final toggleFavoriteProvider = ToggleFavoriteProvider._();

final class ToggleFavoriteProvider
    extends
        $FunctionalProvider<
          ToggleFavoriteUseCase,
          ToggleFavoriteUseCase,
          ToggleFavoriteUseCase
        >
    with $Provider<ToggleFavoriteUseCase> {
  ToggleFavoriteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toggleFavoriteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toggleFavoriteHash();

  @$internal
  @override
  $ProviderElement<ToggleFavoriteUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ToggleFavoriteUseCase create(Ref ref) {
    return toggleFavorite(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ToggleFavoriteUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ToggleFavoriteUseCase>(value),
    );
  }
}

String _$toggleFavoriteHash() => r'0e56ac7bbabc6f424a89fd33d8dd95a84a13be20';

@ProviderFor(removeFromCollection)
final removeFromCollectionProvider = RemoveFromCollectionProvider._();

final class RemoveFromCollectionProvider
    extends
        $FunctionalProvider<
          RemoveFromCollectionUseCase,
          RemoveFromCollectionUseCase,
          RemoveFromCollectionUseCase
        >
    with $Provider<RemoveFromCollectionUseCase> {
  RemoveFromCollectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'removeFromCollectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$removeFromCollectionHash();

  @$internal
  @override
  $ProviderElement<RemoveFromCollectionUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RemoveFromCollectionUseCase create(Ref ref) {
    return removeFromCollection(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoveFromCollectionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoveFromCollectionUseCase>(value),
    );
  }
}

String _$removeFromCollectionHash() =>
    r'50872a86c63e69d08ed7cb7f5206a7240b3ed465';

/// Stream de toda a coleção do utilizador atual.

@ProviderFor(userCollection)
final userCollectionProvider = UserCollectionProvider._();

/// Stream de toda a coleção do utilizador atual.

final class UserCollectionProvider
    extends
        $FunctionalProvider<
          AsyncValue<Either<Failure, List<ComicCollectionEntry>>>,
          Either<Failure, List<ComicCollectionEntry>>,
          Stream<Either<Failure, List<ComicCollectionEntry>>>
        >
    with
        $FutureModifier<Either<Failure, List<ComicCollectionEntry>>>,
        $StreamProvider<Either<Failure, List<ComicCollectionEntry>>> {
  /// Stream de toda a coleção do utilizador atual.
  UserCollectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userCollectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userCollectionHash();

  @$internal
  @override
  $StreamProviderElement<Either<Failure, List<ComicCollectionEntry>>>
  $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<Either<Failure, List<ComicCollectionEntry>>> create(Ref ref) {
    return userCollection(ref);
  }
}

String _$userCollectionHash() => r'e5b299036b02411e546089cc02f0fc3f8d378fe8';

/// Entrada individual de um issue na coleção (null = não está na coleção).

@ProviderFor(collectionEntry)
final collectionEntryProvider = CollectionEntryFamily._();

/// Entrada individual de um issue na coleção (null = não está na coleção).

final class CollectionEntryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ComicCollectionEntry?>,
          ComicCollectionEntry?,
          FutureOr<ComicCollectionEntry?>
        >
    with
        $FutureModifier<ComicCollectionEntry?>,
        $FutureProvider<ComicCollectionEntry?> {
  /// Entrada individual de um issue na coleção (null = não está na coleção).
  CollectionEntryProvider._({
    required CollectionEntryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'collectionEntryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$collectionEntryHash();

  @override
  String toString() {
    return r'collectionEntryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ComicCollectionEntry?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ComicCollectionEntry?> create(Ref ref) {
    final argument = this.argument as String;
    return collectionEntry(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CollectionEntryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$collectionEntryHash() => r'95f0ce19ca425efd163000483b8413258ec8e54f';

/// Entrada individual de um issue na coleção (null = não está na coleção).

final class CollectionEntryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ComicCollectionEntry?>, String> {
  CollectionEntryFamily._()
    : super(
        retry: null,
        name: r'collectionEntryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Entrada individual de um issue na coleção (null = não está na coleção).

  CollectionEntryProvider call(String issueId) =>
      CollectionEntryProvider._(argument: issueId, from: this);

  @override
  String toString() => r'collectionEntryProvider';
}
