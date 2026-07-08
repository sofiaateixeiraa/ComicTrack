import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
part 'auth_providers.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(FirebaseAuthDataSourceImpl());

/// Stream do utilizador atual — null quando não autenticado.
@riverpod
Stream<AppUser?> authState(Ref ref) =>
    ref.watch(authRepositoryProvider).watchAuthState();

/// Utilizador atual de forma síncrona (pode ser null).
@riverpod
AppUser? currentUser(Ref ref) =>
    ref.watch(authStateProvider).asData?.value;