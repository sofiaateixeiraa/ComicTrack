import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_user.dart';

abstract interface class FirebaseAuthDataSource {
  Stream<AppUser?> watchAuthState();
  Future<Either<Failure, AppUser>> signIn({required String email, required String password});
  Future<Either<Failure, AppUser>> register({required String email, required String password});
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, Unit>> resetPassword({required String email});
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth _auth;
  FirebaseAuthDataSourceImpl({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  @override
  Stream<AppUser?> watchAuthState() =>
      _auth.authStateChanges().map((user) => user?.toAppUser());

  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(cred.user!.toAppUser());
    } on FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _mapFirebaseError(e)));
    }
  }

  @override
  Future<Either<Failure, AppUser>> register({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(cred.user!.toAppUser());
    } on FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _mapFirebaseError(e)));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _auth.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(Failure.auth(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _mapFirebaseError(e)));
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) => switch (e.code) {
        'user-not-found' => 'Email não encontrado.',
        'wrong-password' => 'Password incorreta.',
        'email-already-in-use' => 'Email já registado.',
        'weak-password' => 'A password deve ter pelo menos 6 caracteres.',
        'invalid-email' => 'Formato de email inválido.',
        'network-request-failed' => 'Sem ligação à internet.',
        _ => e.message ?? 'Erro de autenticação.',
      };
}

extension on User {
  AppUser toAppUser() => AppUser(
        uid: uid,
        email: email ?? '',
        displayName: displayName,
      );
}