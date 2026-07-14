import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/change_email_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reload_current_user_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/send_email_verification_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_in_with_google_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
part 'auth_providers.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(FirebaseAuthDataSourceImpl());

@riverpod
SignInUseCase signIn(Ref ref) =>
    SignInUseCase(ref.watch(authRepositoryProvider));

@riverpod
RegisterUseCase register(Ref ref) =>
    RegisterUseCase(ref.watch(authRepositoryProvider));

@riverpod
SignInWithGoogleUseCase signInWithGoogle(Ref ref) =>
    SignInWithGoogleUseCase(ref.watch(authRepositoryProvider));

@riverpod
SignOutUseCase signOut(Ref ref) =>
    SignOutUseCase(ref.watch(authRepositoryProvider));

@riverpod
ResetPasswordUseCase resetPassword(Ref ref) =>
    ResetPasswordUseCase(ref.watch(authRepositoryProvider));

@riverpod
ChangeEmailUseCase changeEmail(Ref ref) =>
    ChangeEmailUseCase(ref.watch(authRepositoryProvider));

@riverpod
ChangePasswordUseCase changePassword(Ref ref) =>
    ChangePasswordUseCase(ref.watch(authRepositoryProvider));

@riverpod
SendEmailVerificationUseCase sendEmailVerification(Ref ref) =>
    SendEmailVerificationUseCase(ref.watch(authRepositoryProvider));

@riverpod
ReloadCurrentUserUseCase reloadCurrentUser(Ref ref) =>
    ReloadCurrentUserUseCase(ref.watch(authRepositoryProvider));

/// stream do utilizador atual.
@riverpod
Stream<AppUser?> authState(Ref ref) =>
    ref.watch(authRepositoryProvider).watchAuthState();

/// utilizador atual de forma síncrona.
@riverpod
AppUser? currentUser(Ref ref) => ref.watch(authStateProvider).asData?.value;
