import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;
  AuthRepositoryImpl(this._dataSource);

  @override
  Stream<AppUser?> watchAuthState() => _dataSource.watchAuthState();

  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) => _dataSource.signIn(email: email, password: password);

  @override
  Future<Either<Failure, AppUser>> register({
    required String email,
    required String password,
    String? name,
  }) => _dataSource.register(email: email, password: password, name: name);

  @override
  Future<Either<Failure, AppUser>> signInWithGoogle() =>
      _dataSource.signInWithGoogle();

  @override
  Future<Either<Failure, Unit>> signOut() => _dataSource.signOut();

  @override
  Future<Either<Failure, Unit>> resetPassword({required String email}) =>
      _dataSource.resetPassword(email: email);

  @override
  Future<Either<Failure, Unit>> changeEmail({
    required String currentPassword,
    required String newEmail,
  }) => _dataSource.changeEmail(
    currentPassword: currentPassword,
    newEmail: newEmail,
  );

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => _dataSource.changePassword(
    currentPassword: currentPassword,
    newPassword: newPassword,
  );

  @override
  Future<Either<Failure, Unit>> sendEmailVerification() =>
      _dataSource.sendEmailVerification();

  @override
  Future<Either<Failure, Unit>> reloadCurrentUser() =>
      _dataSource.reloadCurrentUser();
}
