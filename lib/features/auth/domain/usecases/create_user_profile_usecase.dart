import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';

/// cria o documento de perfil do utilizador logo após o registo.
class CreateUserProfileUseCase {
  final UserProfileRepository _repository;
  CreateUserProfileUseCase(this._repository);

  Future<Either<Failure, Unit>> call({
    required String uid,
    required String email,
    required String name,
  }) {
    final profile = UserProfile(
      uid: uid,
      email: email,
      name: name,
      createdAt: DateTime.now(),
    );
    return _repository.createProfile(profile);
  }
}
