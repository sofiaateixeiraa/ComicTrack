import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/user_profile_repository.dart';

/// garante que o perfil tem email/nome preenchidos.
class EnsureUserProfileUseCase {
  final UserProfileRepository _repository;
  EnsureUserProfileUseCase(this._repository);

  Future<Either<Failure, Unit>> call({
    required String uid,
    required String email,
    required String name,
  }) async {
    final existingResult = await _repository.getProfile(uid);
    return existingResult.fold((f) => Left(f), (profile) async {
      if (profile == null) {
        return _repository.createProfile(
          UserProfile(
            uid: uid,
            email: email,
            name: name,
            createdAt: DateTime.now(),
          ),
        );
      }

      if (profile.email != email) {
        final result = await _repository.updateEmail(uid, email);
        if (result.isLeft()) return result;
      }
      if (profile.name.isEmpty) {
        final result = await _repository.updateName(uid, name);
        if (result.isLeft()) return result;
      }
      return const Right(unit);
    });
  }
}
