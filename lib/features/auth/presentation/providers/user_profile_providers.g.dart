// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userProfileRepository)
final userProfileRepositoryProvider = UserProfileRepositoryProvider._();

final class UserProfileRepositoryProvider
    extends
        $FunctionalProvider<
          UserProfileRepository,
          UserProfileRepository,
          UserProfileRepository
        >
    with $Provider<UserProfileRepository> {
  UserProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserProfileRepository create(Ref ref) {
    return userProfileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserProfileRepository>(value),
    );
  }
}

String _$userProfileRepositoryHash() =>
    r'cdd5baac5a36648464f13aebf733e5504b8577dd';

@ProviderFor(createUserProfile)
final createUserProfileProvider = CreateUserProfileProvider._();

final class CreateUserProfileProvider
    extends
        $FunctionalProvider<
          CreateUserProfileUseCase,
          CreateUserProfileUseCase,
          CreateUserProfileUseCase
        >
    with $Provider<CreateUserProfileUseCase> {
  CreateUserProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createUserProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createUserProfileHash();

  @$internal
  @override
  $ProviderElement<CreateUserProfileUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateUserProfileUseCase create(Ref ref) {
    return createUserProfile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateUserProfileUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateUserProfileUseCase>(value),
    );
  }
}

String _$createUserProfileHash() => r'66bf18099eca4bd41234bbc6caa4187f3bb5eae4';

@ProviderFor(ensureUserProfile)
final ensureUserProfileProvider = EnsureUserProfileProvider._();

final class EnsureUserProfileProvider
    extends
        $FunctionalProvider<
          EnsureUserProfileUseCase,
          EnsureUserProfileUseCase,
          EnsureUserProfileUseCase
        >
    with $Provider<EnsureUserProfileUseCase> {
  EnsureUserProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ensureUserProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ensureUserProfileHash();

  @$internal
  @override
  $ProviderElement<EnsureUserProfileUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EnsureUserProfileUseCase create(Ref ref) {
    return ensureUserProfile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EnsureUserProfileUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EnsureUserProfileUseCase>(value),
    );
  }
}

String _$ensureUserProfileHash() => r'f67c73a2eae685ac3cf7b316c2e7fc7f86064736';

@ProviderFor(updateProfilePhoto)
final updateProfilePhotoProvider = UpdateProfilePhotoProvider._();

final class UpdateProfilePhotoProvider
    extends
        $FunctionalProvider<
          UpdateProfilePhotoUseCase,
          UpdateProfilePhotoUseCase,
          UpdateProfilePhotoUseCase
        >
    with $Provider<UpdateProfilePhotoUseCase> {
  UpdateProfilePhotoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateProfilePhotoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateProfilePhotoHash();

  @$internal
  @override
  $ProviderElement<UpdateProfilePhotoUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateProfilePhotoUseCase create(Ref ref) {
    return updateProfilePhoto(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateProfilePhotoUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateProfilePhotoUseCase>(value),
    );
  }
}

String _$updateProfilePhotoHash() =>
    r'2685ed9388d6bfa8a323fe7d5648a99f676e6bb6';

@ProviderFor(updateProfileName)
final updateProfileNameProvider = UpdateProfileNameProvider._();

final class UpdateProfileNameProvider
    extends
        $FunctionalProvider<
          UpdateProfileNameUseCase,
          UpdateProfileNameUseCase,
          UpdateProfileNameUseCase
        >
    with $Provider<UpdateProfileNameUseCase> {
  UpdateProfileNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateProfileNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateProfileNameHash();

  @$internal
  @override
  $ProviderElement<UpdateProfileNameUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateProfileNameUseCase create(Ref ref) {
    return updateProfileName(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateProfileNameUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateProfileNameUseCase>(value),
    );
  }
}

String _$updateProfileNameHash() => r'93c7a9aed76e2ceabf390881463ca6d3a9cd0755';

/// stream reativo do perfil do utilizador atual.

@ProviderFor(userProfile)
final userProfileProvider = UserProfileProvider._();

/// stream reativo do perfil do utilizador atual.

final class UserProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<Either<Failure, UserProfile?>>,
          Either<Failure, UserProfile?>,
          Stream<Either<Failure, UserProfile?>>
        >
    with
        $FutureModifier<Either<Failure, UserProfile?>>,
        $StreamProvider<Either<Failure, UserProfile?>> {
  /// stream reativo do perfil do utilizador atual.
  UserProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileHash();

  @$internal
  @override
  $StreamProviderElement<Either<Failure, UserProfile?>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Either<Failure, UserProfile?>> create(Ref ref) {
    return userProfile(ref);
  }
}

String _$userProfileHash() => r'0b7388a12832eb6df2a501b1ab58135901e8977c';
