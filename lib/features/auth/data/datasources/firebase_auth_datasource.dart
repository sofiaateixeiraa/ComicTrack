import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_user.dart';

abstract interface class FirebaseAuthDataSource {
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

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  FirebaseAuthDataSourceImpl({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
    : _auth = auth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Stream<AppUser?> watchAuthState() =>
      _auth.userChanges().map((user) => user?.toAppUser());

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
    String? name,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (name != null && name.isNotEmpty) {
        await cred.user!.updateDisplayName(name);
      }
      await cred.user!.sendEmailVerification();
      return Right(
        AppUser(
          uid: cred.user!.uid,
          email: cred.user!.email ?? '',
          displayName: name,
          hasPasswordProvider: true,
          emailVerified: false,
        ),
      );
    } on FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _mapFirebaseError(e)));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return Left(Failure.auth(message: 'Login com Google cancelado.'));
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final cred = await _auth.signInWithCredential(credential);
      return Right(cred.user!.toAppUser());
    } on FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _mapFirebaseError(e)));
    } catch (_) {
      return Left(
        Failure.auth(message: 'Não foi possível iniciar sessão com o Google.'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
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

  @override
  Future<Either<Failure, Unit>> changeEmail({
    required String currentPassword,
    required String newEmail,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        return Left(
          Failure.auth(message: 'Sessão inválida. Inicie sessão de novo.'),
        );
      }
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.verifyBeforeUpdateEmail(newEmail);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _mapFirebaseError(e)));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        return Left(
          Failure.auth(message: 'Sessão inválida. Inicie sessão de novo.'),
        );
      }
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _mapFirebaseError(e)));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return Left(Failure.auth(message: 'Sessão inválida.'));
      await user.sendEmailVerification();
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _mapFirebaseError(e)));
    }
  }

  @override
  Future<Either<Failure, Unit>> reloadCurrentUser() async {
    try {
      await _auth.currentUser?.reload();
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(Failure.auth(message: _mapFirebaseError(e)));
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) => switch (e.code) {
    'user-not-found' => 'Email não encontrado.',
    'wrong-password' => 'Palavra-passe incorreta.',
    'invalid-credential' => 'Palavra-passe incorreta.',
    'email-already-in-use' => 'Email já registado.',
    'weak-password' => 'A palavra-passe deve ter pelo menos 6 caracteres.',
    'invalid-email' => 'Formato de email inválido.',
    'network-request-failed' => 'Sem ligação à internet.',
    'requires-recent-login' =>
      'Por segurança, tens de voltar a confirmar a tua password.',
    'too-many-requests' =>
      'Demasiados pedidos. Espera um pouco antes de tentar novamente.',
    _ => e.message ?? 'Erro de autenticação.',
  };
}

extension on User {
  AppUser toAppUser() => AppUser(
    uid: uid,
    email: email ?? '',
    displayName: displayName,
    hasPasswordProvider: providerData.any((p) => p.providerId == 'password'),
    emailVerified: emailVerified,
  );
}
