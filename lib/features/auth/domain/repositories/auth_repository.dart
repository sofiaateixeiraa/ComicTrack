import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';

abstract interface class AuthRepository {
  Stream<AppUser?> watchAuthState();
  Future<Either<Failure, AppUser>> signIn({required String email, required String password});
  Future<Either<Failure, AppUser>> register({required String email, required String password});
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, Unit>> resetPassword({required String email});
}