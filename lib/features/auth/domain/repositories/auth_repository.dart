import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';

abstract interface class AuthRepository {
  Stream<AppUser?> watchAuthState();
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  });
  Future<Either<Failure, AppUser>> register({
    required String email,
    required String password,
    String? name,
  });
  Future<Either<Failure, AppUser>> signInWithGoogle();
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, Unit>> resetPassword({required String email});
  Future<Either<Failure, Unit>> changeEmail({
    required String currentPassword,
    required String newEmail,
  });
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<Either<Failure, Unit>> sendEmailVerification();
  Future<Either<Failure, Unit>> reloadCurrentUser();
}
