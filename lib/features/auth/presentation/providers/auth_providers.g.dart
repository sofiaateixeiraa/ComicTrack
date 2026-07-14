// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'a76f37a4d3603baa24dd02bfc4c73f481ee821f6';

@ProviderFor(signIn)
final signInProvider = SignInProvider._();

final class SignInProvider
    extends $FunctionalProvider<SignInUseCase, SignInUseCase, SignInUseCase>
    with $Provider<SignInUseCase> {
  SignInProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInHash();

  @$internal
  @override
  $ProviderElement<SignInUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SignInUseCase create(Ref ref) {
    return signIn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignInUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignInUseCase>(value),
    );
  }
}

String _$signInHash() => r'814a73b1c39007a565d2ac592a26ce70b82ab5ea';

@ProviderFor(register)
final registerProvider = RegisterProvider._();

final class RegisterProvider
    extends
        $FunctionalProvider<RegisterUseCase, RegisterUseCase, RegisterUseCase>
    with $Provider<RegisterUseCase> {
  RegisterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerHash();

  @$internal
  @override
  $ProviderElement<RegisterUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RegisterUseCase create(Ref ref) {
    return register(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterUseCase>(value),
    );
  }
}

String _$registerHash() => r'2cae90ba27405fb7dfdf4e4899bdb199632a5703';

@ProviderFor(signInWithGoogle)
final signInWithGoogleProvider = SignInWithGoogleProvider._();

final class SignInWithGoogleProvider
    extends
        $FunctionalProvider<
          SignInWithGoogleUseCase,
          SignInWithGoogleUseCase,
          SignInWithGoogleUseCase
        >
    with $Provider<SignInWithGoogleUseCase> {
  SignInWithGoogleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInWithGoogleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInWithGoogleHash();

  @$internal
  @override
  $ProviderElement<SignInWithGoogleUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SignInWithGoogleUseCase create(Ref ref) {
    return signInWithGoogle(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignInWithGoogleUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignInWithGoogleUseCase>(value),
    );
  }
}

String _$signInWithGoogleHash() => r'0828a712488dcb77213bb8680c6f76b4e9f8064f';

@ProviderFor(signOut)
final signOutProvider = SignOutProvider._();

final class SignOutProvider
    extends $FunctionalProvider<SignOutUseCase, SignOutUseCase, SignOutUseCase>
    with $Provider<SignOutUseCase> {
  SignOutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signOutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signOutHash();

  @$internal
  @override
  $ProviderElement<SignOutUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SignOutUseCase create(Ref ref) {
    return signOut(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignOutUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignOutUseCase>(value),
    );
  }
}

String _$signOutHash() => r'5ce609cf1711a4ee37dbad8bb490bdf81b8b65f4';

@ProviderFor(resetPassword)
final resetPasswordProvider = ResetPasswordProvider._();

final class ResetPasswordProvider
    extends
        $FunctionalProvider<
          ResetPasswordUseCase,
          ResetPasswordUseCase,
          ResetPasswordUseCase
        >
    with $Provider<ResetPasswordUseCase> {
  ResetPasswordProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetPasswordProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetPasswordHash();

  @$internal
  @override
  $ProviderElement<ResetPasswordUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ResetPasswordUseCase create(Ref ref) {
    return resetPassword(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResetPasswordUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResetPasswordUseCase>(value),
    );
  }
}

String _$resetPasswordHash() => r'6fa5b12ca97d301b649e511b070b2b87bbb1b0c5';

@ProviderFor(changeEmail)
final changeEmailProvider = ChangeEmailProvider._();

final class ChangeEmailProvider
    extends
        $FunctionalProvider<
          ChangeEmailUseCase,
          ChangeEmailUseCase,
          ChangeEmailUseCase
        >
    with $Provider<ChangeEmailUseCase> {
  ChangeEmailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changeEmailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changeEmailHash();

  @$internal
  @override
  $ProviderElement<ChangeEmailUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChangeEmailUseCase create(Ref ref) {
    return changeEmail(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChangeEmailUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChangeEmailUseCase>(value),
    );
  }
}

String _$changeEmailHash() => r'd7d47429d24bbacb1f3ea6892bf2eb2adb07e38c';

@ProviderFor(changePassword)
final changePasswordProvider = ChangePasswordProvider._();

final class ChangePasswordProvider
    extends
        $FunctionalProvider<
          ChangePasswordUseCase,
          ChangePasswordUseCase,
          ChangePasswordUseCase
        >
    with $Provider<ChangePasswordUseCase> {
  ChangePasswordProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changePasswordProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changePasswordHash();

  @$internal
  @override
  $ProviderElement<ChangePasswordUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChangePasswordUseCase create(Ref ref) {
    return changePassword(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChangePasswordUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChangePasswordUseCase>(value),
    );
  }
}

String _$changePasswordHash() => r'e759acdaca3f031a87cd85e8de055735fa1d71a2';

@ProviderFor(sendEmailVerification)
final sendEmailVerificationProvider = SendEmailVerificationProvider._();

final class SendEmailVerificationProvider
    extends
        $FunctionalProvider<
          SendEmailVerificationUseCase,
          SendEmailVerificationUseCase,
          SendEmailVerificationUseCase
        >
    with $Provider<SendEmailVerificationUseCase> {
  SendEmailVerificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendEmailVerificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendEmailVerificationHash();

  @$internal
  @override
  $ProviderElement<SendEmailVerificationUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SendEmailVerificationUseCase create(Ref ref) {
    return sendEmailVerification(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendEmailVerificationUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendEmailVerificationUseCase>(value),
    );
  }
}

String _$sendEmailVerificationHash() =>
    r'92405f1af1040774371b4e4e46330ff778883b5e';

@ProviderFor(reloadCurrentUser)
final reloadCurrentUserProvider = ReloadCurrentUserProvider._();

final class ReloadCurrentUserProvider
    extends
        $FunctionalProvider<
          ReloadCurrentUserUseCase,
          ReloadCurrentUserUseCase,
          ReloadCurrentUserUseCase
        >
    with $Provider<ReloadCurrentUserUseCase> {
  ReloadCurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reloadCurrentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reloadCurrentUserHash();

  @$internal
  @override
  $ProviderElement<ReloadCurrentUserUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReloadCurrentUserUseCase create(Ref ref) {
    return reloadCurrentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReloadCurrentUserUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReloadCurrentUserUseCase>(value),
    );
  }
}

String _$reloadCurrentUserHash() => r'764aba04369f08abec59297a5cf1fea71f115579';

/// stream do utilizador atual.

@ProviderFor(authState)
final authStateProvider = AuthStateProvider._();

/// stream do utilizador atual.

final class AuthStateProvider
    extends
        $FunctionalProvider<AsyncValue<AppUser?>, AppUser?, Stream<AppUser?>>
    with $FutureModifier<AppUser?>, $StreamProvider<AppUser?> {
  /// stream do utilizador atual.
  AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  $StreamProviderElement<AppUser?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AppUser?> create(Ref ref) {
    return authState(ref);
  }
}

String _$authStateHash() => r'f454ffbf1df99f90dcc882830d5dd805463aca24';

/// utilizador atual de forma síncrona.

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// utilizador atual de forma síncrona.

final class CurrentUserProvider
    extends $FunctionalProvider<AppUser?, AppUser?, AppUser?>
    with $Provider<AppUser?> {
  /// utilizador atual de forma síncrona.
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<AppUser?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppUser? create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppUser? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppUser?>(value),
    );
  }
}

String _$currentUserHash() => r'2f32aff5c52d437c236610e74e0e0b2173ab2692';
