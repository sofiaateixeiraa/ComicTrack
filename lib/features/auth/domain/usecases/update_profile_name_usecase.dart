import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/user_profile_repository.dart';

class UpdateProfileNameUseCase {
  final UserProfileRepository _repository;
  UpdateProfileNameUseCase(this._repository);

  Future<Either<Failure, Unit>> call({
    required String uid,
    required String name,
  }) => _repository.updateName(uid, name);
}
