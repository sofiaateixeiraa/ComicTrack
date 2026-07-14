import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';

abstract interface class UserProfileRepository {
  /// cria ou substitui o documento de perfil de um utilizador novo.
  Future<Either<Failure, Unit>> createProfile(UserProfile profile);

  /// leitura pontual do perfil.
  Future<Either<Failure, UserProfile?>> getProfile(String uid);

  /// stream reativo do perfil.
  Stream<Either<Failure, UserProfile?>> watchProfile(String uid);

  /// atualiza apenas a foto de perfil, já comprimida e em base64.
  Future<Either<Failure, Unit>> updatePhoto(String uid, String photoBase64);

  /// atualiza apenas o nome de perfil.
  Future<Either<Failure, Unit>> updateName(String uid, String name);

  /// atualiza apenas o email de perfil.
  Future<Either<Failure, Unit>> updateEmail(String uid, String email);
}
